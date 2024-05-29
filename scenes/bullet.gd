extends CharacterBody2D

@export var player_group = 'null'
@export var durability = 1

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
		return_piece()
		collider.queue_free()
	elif collider.is_in_group("brick"):
		collider.queue_free()

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

@rpc("authority", "call_local", "reliable")
func return_piece():
	var piece = get_child(3)
	if piece != null:
		if player_group == 'orange':
			piece.global_position = Vector2(global_position.x, 470)
		else:
			piece.global_position = Vector2(global_position.x, 80)
		piece.call_deferred("reparent", get_tree().get_root().get_node("/root/Main/PiecesShow"))
		queue_free()
