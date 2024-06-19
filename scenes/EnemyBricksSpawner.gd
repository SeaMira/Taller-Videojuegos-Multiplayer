extends Node

@onready var timer = $Timer

var base_size = Vector2i(960, 540) 
var piece_size = base_size * (0.6/PuzzleSettings.PUZZLE_PIECES)
var puzzle_dim = PuzzleSettings.PUZZLE_PIECES
var scale_factor = Vector2(1.0, 1.0)

func _ready():
	print('called _ready')
	spawn_bricks.rpc()

func _process(delta):
	var total_bricks = PuzzleSettings.total_bricks_in_game
	var current_bricks = PuzzleSettings.current_bricks_in_game
	if total_bricks != null:
		if total_bricks > current_bricks:
			timer.start()
			if (current_bricks + 1) == total_bricks:
				PuzzleSettings.current_bricks_in_game = total_bricks
			else:
				PuzzleSettings.current_bricks_in_game = current_bricks + 1
		
@rpc("authority", "call_local", "reliable")
func spawn_bricks():
	if multiplayer.is_server():
		var rng = RandomNumberGenerator.new()
		var number_of_bricks = rng.randi_range(puzzle_dim * 2 - 2, puzzle_dim * 2)
		var positions_taken = []
		
		PuzzleSettings.total_bricks_in_game = number_of_bricks
		PuzzleSettings.current_bricks_in_game = number_of_bricks
		print(PuzzleSettings.total_bricks_in_game, PuzzleSettings.total_bricks_in_game)
		
		for value in range(number_of_bricks):
			var position_rand = get_coords(positions_taken, puzzle_dim)
			positions_taken.append(position_rand)
			var i = position_rand[0]
			var j = position_rand[1]
			var position =  Vector2(j * ((piece_size.x * scale_factor.x)/2), i * ((piece_size.y * scale_factor.y)/2))
			position -= piece_size/2
			var v_pos = Vector2(base_size*(0.2)) + Vector2(piece_size/2)
			sync_brick.rpc(position + v_pos, [i,j])
		print(positions_taken)
		PuzzleSettings.bricks_coords_taken = positions_taken
			
@rpc("any_peer", "call_local", "reliable")
func sync_brick(move_position, coords):
	var brick = load("res://scenes/enemy_brick.tscn").instantiate()
	brick.name = 'brick_' + str(coords[0]) + '_' + str(coords[1])
	add_child(brick)
	brick.position = move_position
	brick.positioned = true
	brick.coord = coords
	
func get_coords(positions_list, puzzle_dim):
	while true:
		var rng_i = RandomNumberGenerator.new()
		var rng_j = RandomNumberGenerator.new()
		var i = rng_i.randi_range(0, (puzzle_dim * 2) - 1)
		var j = rng_j.randi_range(0, (puzzle_dim * 2) - 1)
		if [i,j] not in positions_list:
			return [i, j]
			
func _on_timer_timeout():
	respawn_brick.rpc()

@rpc("authority", "call_local", "reliable")
func respawn_brick():
	if multiplayer.is_server():
		var position_rand = get_coords(PuzzleSettings.bricks_coords_taken, puzzle_dim)
		PuzzleSettings.bricks_coords_taken.append(position_rand)
		var i = position_rand[0]
		var j = position_rand[1]
		var position =  Vector2(j * ((piece_size.x * scale_factor.x)/2), i * ((piece_size.y * scale_factor.y)/2))
		position -= piece_size/2
		var v_pos = Vector2(base_size*(0.2)) + Vector2(piece_size/2)
		sync_brick.rpc(position + v_pos, [i,j])
		print(PuzzleSettings.bricks_coords_taken)
		
	
