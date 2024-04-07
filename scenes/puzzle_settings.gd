extends Node

var PUZZLE_IMAGE = null
var PUZZLE_PIECES = null
var pieces: Array[PuzzlePieceData] = []
var PUZZLE_SCALE = null

enum Rotation {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

class PuzzlePieceData:
	var idx: int
	var idy: int
	var body: RigidBody2D
	var rotation: Rotation
	
	func _init(new_idx: int, new_idy: int, new_body: RigidBody2D, new_rotation: Rotation = Rotation.UP) -> void:
		idx = new_idx
		idy = new_idy
		body = new_body
		rotation = new_rotation
	
	func to_dict() -> Dictionary:
		return {
			"idx": idx,
			"idy": idy,
			"body": body,
			"rotation": rotation
		}


func search_piece(piece: RigidBody2D):
	for p in pieces:
		if p.body == piece:
			return Vector2(p.idx, p.idy)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
