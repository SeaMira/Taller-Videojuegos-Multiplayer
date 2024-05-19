extends Node2D
@onready var sprite = $Sprite2D
@onready var enemy_brick = $"."

var base_size = Vector2i(960, 540) 
var piece_size = base_size * (0.6/PuzzleSettings.PUZZLE_PIECES)

func _ready():
	var brick_scale_factor = (piece_size / (sprite.texture.get_size()*2))
	enemy_brick.scale = brick_scale_factor

func _process(delta):
	pass
