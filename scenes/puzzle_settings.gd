extends Node

var PUZZLE_IMAGE = null
var PUZZLE_PIECES = null
var pieces: Array[PuzzlePieceData] = []

enum Rotation {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

class PuzzlePieceData:
	var idx: int
	var idy: int
	var sprite: Sprite2D
	var rotation: Rotation
	
	func _init(new_idx: int, new_idy: int, new_sprite: Sprite2D, new_rotation: Rotation = Rotation.UP) -> void:
		idx = new_idx
		idy = new_idy
		sprite = new_sprite
		rotation = new_rotation
	
	func to_dict() -> Dictionary:
		return {
			"idx": idx,
			"idy": idy,
			"sprite": sprite,
			"rotation": rotation
		}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
