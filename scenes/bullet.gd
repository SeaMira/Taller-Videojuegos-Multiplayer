extends CharacterBody2D

@export var player_group = 'null'

func _ready():
	add_to_group(player_group)


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)

func handle_collision(collision : KinematicCollision2D):
	velocity = velocity.bounce(collision.get_normal())
	

func set_group(group):
	player_group = group
