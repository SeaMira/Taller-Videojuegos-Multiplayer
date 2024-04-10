extends Node

@onready var pieces_show = $"."
var puzzle: Sprite2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	puzzle = Sprite2D.new()
	#puzzle.modulate.a = 0.5
	puzzle.texture = PuzzleSettings.PUZZLE_IMAGE
	puzzle.scale = PuzzleSettings.PUZZLE_SCALE
	puzzle.position = get_viewport().size/2
	puzzle.modulate.a = 0.3
	add_child(puzzle)
	
	var start_position = Vector2(50, 50) # Posición inicial de la cuadrícula
	var margin = 0 # Margen entre piezas
	var piece_size = get_viewport().size * (0.6/PuzzleSettings.PUZZLE_PIECES) # Asume un tamaño fijo para las piezas
	var scale_factor = Vector2(1.0, 1.0)
	var n = PuzzleSettings.PUZZLE_PIECES

	for i in range(n):
		for j in range(n):
			var indx = i * n + j
			# Accede directamente al RigidBody2D almacenado
			var piece_body = PuzzleSettings.pieces[indx].body
			add_child(piece_body)
			# Calcula la posición basándote en el tamaño de la pieza, escala, y márgenes
			var position = start_position + Vector2(j * (piece_size.x * scale_factor.x + margin), i * (piece_size.y * scale_factor.y + margin))
			piece_body.position = position
			#piece_body.scale = scale_factor
			# Configura los RigidBody2D para ser estáticos o kinemáticos según lo necesites aquí
			# piece_body.mode = RigidBody2D.MODE_STATIC o RigidBody2D.MODE_KINEMATIC
			var v_pos = Vector2(get_viewport().size/4) - start_position 
			piece_places_setup(i, j, piece_size.x, piece_size.y, position + v_pos)
			
			
	
func piece_places_setup(i, j, width, height, pos):
	var area = Area2D.new()
	var shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = Vector2(width / 2, height / 2)
	shape.shape = rect_shape
	area.add_child(shape)
	#area.position = pos - Vector2(width*0.3, height*0.3) + Vector2(width*0.5, height*0.5)
	area.position = pos - Vector2(width*0.82, height*0.82)
	area.name = "celda_" + str(i) + "_" + str(j)
	area.collision_layer = 2
	area.collision_mask = 1
	area.body_entered.connect(_on_cell_body_entered.bind(area))
	add_child(area) # Asegúrate de que este script esté adjunto a un nodo que pueda ser padre de Area2D

	
	
func _on_cell_body_entered(body, area):
	#var indxs = PuzzleSettings.search_piece(body)
	#var body_name = "celda_" + str(indxs.x) + "_" + str(indxs.y)
	#if area.name == body_name:
		#print("algo entró ", area.name)
	print("wena")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
