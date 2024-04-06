extends MultiplayerSynchronizer

@export var move_input: Vector2 = Vector2.ZERO
@export var is_bullet: bool = 0

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		move_input = Input.get_vector("left", "right", "up", "down")
		if Input.is_action_just_pressed("test"):
			is_bullet = 1
		else:
			is_bullet = 0
