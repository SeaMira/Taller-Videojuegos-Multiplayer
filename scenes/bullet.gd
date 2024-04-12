extends CharacterBody2D

@export var speed = 200

func _ready():
	set_velocity(Vector2(200, 0))

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)


func handle_collision(collision : KinematicCollision2D):
	velocity = velocity.bounce(collision.get_normal())
