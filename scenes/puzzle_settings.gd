extends Node

var PUZZLE_IMAGE = null
var PUZZLE_PIECES = null
var orange_pieces: Array[PuzzlePieceData] = []
var blue_pieces: Array[PuzzlePieceData] = []
var PUZZLE_SCALE = null
var PIECE_WIDTH = null
var PIECE_HEIGHT = null

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


func search_blue_piece(piece: RigidBody2D):
	for p in blue_pieces:
		var n = p.body.name
		if n == piece.name:
			return Vector2(p.idx, p.idy)
			
func search_orange_piece(piece: RigidBody2D):
	for p in orange_pieces:
		var n = p.body.name
		if n == piece.name:
			return Vector2(p.idx, p.idy)
			
func clean_by_ids(x, y):
	var sz = blue_pieces.size()
	var sz2 = orange_pieces.size()
	var o_ok = false
	var b_ok = false
	for i in range(sz):
		if !o_ok and orange_pieces[i].idx == x and orange_pieces[i].idy == y :
			orange_pieces[i].body.queue_free()
			orange_pieces.remove_at(i)
			o_ok = true
		if !b_ok and blue_pieces[i].idx == x and blue_pieces[i].idy == y:
			blue_pieces[i].body.queue_free()
			blue_pieces.remove_at(i)
			b_ok = true
	if (blue_pieces.size() == 0 and orange_pieces.size() == 0):
		get_tree().change_scene_to_file("res://scenes/victory/GameOverScene.tscn")

