extends CharacterBody2D


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func handle_collision(collision : KinematicCollision2D):
	queue_free()
