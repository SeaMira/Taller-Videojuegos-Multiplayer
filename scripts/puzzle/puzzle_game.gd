extends Node

@onready var pieces_show = $"."
var puzzle: Sprite2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var start_position = Vector2(100, 100) # Posición inicial de la cuadrícula
	var margin = 1 # Margen entre piezas
	var piece_size = Vector2(32, 32) # Asume un tamaño fijo para las piezas
	var scale_factor = Vector2(1.5, 1.5)
	var n = PuzzleSettings.PUZZLE_PIECES
	for i in range(n):
		for j in range(n):
			var indx = i*n+j
			var sprt = PuzzleSettings.pieces[indx].to_dict().sprite
			pieces_show.add_child(sprt)
			var position = start_position + Vector2(j * (piece_size.x + margin), i * (piece_size.y + margin))
			sprt.position = position
			sprt.scale = scale_factor
			print(sprt)
			
	puzzle = Sprite2D.new()
	puzzle.modulate.a = 0.5
	puzzle.texture = PuzzleSettings.PUZZLE_IMAGE
	puzzle.scale = Vector2(2.5, 2.5)
	puzzle.position = get_viewport().size/2
	add_child(puzzle)


func piece_places_setup():
	var piece_width = PuzzleSettings.PUZZLE_IMAGE.get_width()/PuzzleSettings.PUZZLE_PIECES
	var piece_height = PuzzleSettings.PUZZLE_IMAGE.get_height()/PuzzleSettings.PUZZLE_PIECES
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
