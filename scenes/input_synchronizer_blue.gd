extends MultiplayerSynchronizer

@export var move_input: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		move_input = Input.get_vector("left", "right", "up", "down")
