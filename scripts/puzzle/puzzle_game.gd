extends Node

@onready var pieces_show = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	var start_position = Vector2(100, 100) # Posición inicial de la cuadrícula
	var margin = 10 # Margen entre piezas
	var piece_size = Vector2(64, 64) # Asume un tamaño fijo para las piezas
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
