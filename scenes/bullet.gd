extends CharacterBody2D

func _ready():
	if get_child(3):
		show_piece.rpc()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func handle_collision(collision : KinematicCollision2D):
	velocity = velocity.bounce(collision.get_normal())

@rpc("any_peer", "call_local", "reliable")
func show_piece():
	var bullets = get_node("/root/Main/Bullets").get_children()
	for bullet in bullets:
		bullet.get_child(3).show()
