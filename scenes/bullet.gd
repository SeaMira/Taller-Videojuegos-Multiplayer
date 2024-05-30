extends CharacterBody2D

@export var player_group = 'null'
@export var durability = 1
var base_size = Vector2i(960, 540) 

func _ready():
	if get_child(3):
		show_piece.rpc()
	if player_group != 'null':
		add_to_group(player_group)
		

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func handle_collision(collision : KinematicCollision2D):
	velocity = velocity.bounce(collision.get_normal())
	var collider = collision.get_collider()
	if collider.is_in_group("projectile"):
		return_piece.rpc()
	elif collider.is_in_group("brick"):
		collider.queue_free()
	elif (collider.is_in_group('orange') and player_group != 'orange') or (collider.is_in_group('blue') and player_group != 'blue'):
		prueba.rpc()

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

@rpc("any_peer", "call_local", "reliable")
func prueba():
	var idxs = name.split("_")
	var x = int(idxs[1])
	var y = int(idxs[2])
	place_piece_image(x, y)
	PuzzleSettings.clean_by_ids(x, y)

func set_group(group):
	player_group = group

@rpc("any_peer", "call_local", "reliable")
func show_piece():
	get_child(3).show()

@rpc("authority", "call_local", "reliable")
func reduce_durability():
	durability = durability - 1

@rpc("authority", "call_local", "reliable")
func check_durability():
	if durability == 0:
		return_piece.rpc()

@rpc("any_peer", "call_local", "reliable")
func return_piece():
	var piece = get_child(3)
	if piece != null:
		if player_group == 'orange':
			piece.global_position = Vector2(global_position.x, 470)
		else:
			piece.global_position = Vector2(global_position.x, 80)
		piece.call_deferred("reparent", get_tree().get_root().get_node("/root/Main/PiecesShow"))
		queue_free()
