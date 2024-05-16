extends Node

var base_size = Vector2i(960, 540) 

@onready var pieces_show = $"."
var puzzle: Sprite2D = null
var PIECE_SIZE = null
# Called when the node enters the scene tree for the first time.
func _ready():
	set_multiplayer_authority(multiplayer.get_unique_id())
	puzzle = Sprite2D.new()
	#puzzle.modulate.a = 0.5
	puzzle.texture = PuzzleSettings.PUZZLE_IMAGE
	puzzle.scale = PuzzleSettings.PUZZLE_SCALE
	puzzle.position = base_size/2
	puzzle.modulate.a = 0.3
	add_child(puzzle)
	
	
	var start_position = Vector2(50, 50) # Posición inicial de la cuadrícula
	var margin = 0 # Margen entre piezas
	var piece_size = base_size * (0.6/PuzzleSettings.PUZZLE_PIECES) # Asume un tamaño fijo para las piezas
	PIECE_SIZE = piece_size
	var scale_factor = Vector2(1.0, 1.0)
	var n = PuzzleSettings.PUZZLE_PIECES

	for i in range(n):
		for j in range(n):
			var position =  Vector2(j * (piece_size.x * scale_factor.x + margin), i * (piece_size.y * scale_factor.y + margin))
			var v_pos = Vector2(base_size*(0.2)) + Vector2(piece_size/2)
			piece_places_setup(i, j, piece_size.x, piece_size.y, position + v_pos )
			if multiplayer.is_server():
				var rng = RandomNumberGenerator.new()
				var rngx = rng.randf()
				var rngy = rng.randf()
				place_blue_piece.rpc(i, j, n, rngx, rngy)
				place_orange_piece.rpc(i, j, n, rngx, rngy)



func piece_places_setup(i, j, width, height, pos):
	var area = Area2D.new()
	var shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = Vector2(width / 2, height / 2)
	shape.shape = rect_shape
	area.add_child(shape)
	#area.position = pos - Vector2(width*0.3, height*0.3) + Vector2(width*0.5, height*0.5)
	area.position = pos 
	area.name = "celda_" + str(i) + "_" + str(j)
	area.collision_layer = 2
	area.collision_mask = 1
	area.body_entered.connect(_on_cell_body_entered.bind(area))
	add_child(area) # Asegúrate de que este script esté adjunto a un nodo que pueda ser padre de Area2D

@rpc("any_peer", "call_local", "reliable")
func place_blue_piece(i, j, n, rngx, rngy):
	var indx = i * n + j
	# Accede directamente al RigidBody2D almacenado
	var piece_body = PuzzleSettings.blue_pieces[indx].body
	piece_body.z_index = indx
	add_child(piece_body)
	piece_body.add_to_group("blue")
	var viewport_size = base_size
	# Calcula la posición basándote en el tamaño de la pieza, escala, y márgenes
	var position = Vector2(viewport_size.x*(0.8 + 0.17*rngx), viewport_size.y*(0.55 + 0.42*rngy))
	piece_body.position = position
	#piece_body.scale = scale_factor
	# Configura los RigidBody2D para ser estáticos o kinemáticos según lo necesites aquí
	# piece_body.mode = RigidBody2D.MODE_STATIC o RigidBody2D.MODE_KINEMATIC
	
@rpc("any_peer", "call_local", "reliable")
func place_orange_piece(i, j, n, rngx, rngy):
	var indx = i * n + j
	# Accede directamente al RigidBody2D almacenado
	var piece_body = PuzzleSettings.orange_pieces[indx].body
	piece_body.z_index = indx
	add_child(piece_body)
	piece_body.add_to_group("orange")
	var viewport_size = base_size
	# Calcula la posición basándote en el tamaño de la pieza, escala, y márgenes
	var position = Vector2(viewport_size.x*(0.8 + 0.2*rngx), viewport_size.y*(0.03 + 0.42*rngy))
	piece_body.position = position
	#piece_body.scale = scale_factor
	# Configura los RigidBody2D para ser estáticos o kinemáticos según lo necesites aquí
	# piece_body.mode = RigidBody2D.MODE_STATIC o RigidBody2D.MODE_KINEMATIC
	

func _on_cell_body_entered(body, area):
	if is_multiplayer_authority():
		var bodies = area.get_overlapping_bodies()
		if body.is_in_group("blue") and !(body is CharacterBody2D):
			var indxs = PuzzleSettings.search_blue_piece(body)
			var body_name = "celda_" + str(indxs.x) + "_" + str(indxs.y)
			#print("body name", body_name, area.name)
			if area.name == body_name:
				if bodies.size() >= 2:
					#print("bodies size")
					for b in bodies:
						if b.is_in_group("orange"):
							var indxs2 = PuzzleSettings.search_orange_piece(b)
							var b_name = "celda_" + str(indxs2.x) + "_" + str(indxs2.y)
							#print(b_name, body_name)
							if body_name == b_name:
								prueba.rpc(area.name)
		elif body.is_in_group("orange") and !(body is CharacterBody2D):
			var indxs = PuzzleSettings.search_orange_piece(body)
			var body_name = "celda_" + str(indxs.x) + "_" + str(indxs.y)
			#print("body name", body_name, area.name)
			if area.name == body_name:
				if bodies.size() >= 2:
					#print("bodies size")
					for b in bodies:
						if b.is_in_group("blue"):
							var indxs2 = PuzzleSettings.search_blue_piece(b)
							var b_name = "celda_" + str(indxs2.x) + "_" + str(indxs2.y)
							#print(b_name, body_name)
							if body_name == b_name:
								prueba.rpc(area.name)
		
@rpc("any_peer", "call_local", "reliable")
func prueba(area_name):
	var idxs = area_name.split("_")
	var x = int(idxs[1])
	var y = int(idxs[2])
	print(x, y)
	place_piece_image(x, y)
	PuzzleSettings.clean_by_ids(x, y)
	#print("tariamo entonce")


func place_piece_image(x, y):
	var piece = Sprite2D.new()
	#puzzle.modulate.a = 0.5
	var w = PuzzleSettings.PUZZLE_IMAGE.get_width()/PuzzleSettings.PUZZLE_PIECES 
	var h = PuzzleSettings.PUZZLE_IMAGE.get_height()/PuzzleSettings.PUZZLE_PIECES
	piece.texture = PuzzleSettings.PUZZLE_IMAGE
	piece.region_enabled = true
	piece.region_rect = Rect2(y * w, x * h, w, h)
	piece.scale = PuzzleSettings.PUZZLE_SCALE
	var offsetx = ((y- (int((PuzzleSettings.PUZZLE_PIECES)/2)+1/2))*w + w/2)*PuzzleSettings.PUZZLE_SCALE.x
	var offsety = ((x- (int((PuzzleSettings.PUZZLE_PIECES)/2)))*h + h/2)*PuzzleSettings.PUZZLE_SCALE.y
	piece.position = base_size/2 + Vector2i(offsetx, offsety)
	add_child(piece)
