extends CharacterBody2D

@export var player_group = 'null'

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

func set_group(group):
	player_group = group

@rpc("any_peer", "call_local", "reliable")
func show_piece():
	var bullets = get_node("/root/Main/Bullets").get_children()
	for bullet in bullets:
		bullet.get_child(3).show()

