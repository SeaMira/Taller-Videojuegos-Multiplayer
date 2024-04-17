extends MultiplayerSynchronizer

@export var move_input: Vector2 = Vector2.ZERO
@export var is_bullet: bool = 0
@export var grab_piece: bool = 0
@export var free_piece: bool = 0

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		move_input = Input.get_vector("left", "right", "up", "down")
		is_bullet = Input.is_action_just_pressed("test")
		grab_piece = Input.is_action_just_pressed("grab")
		free_piece = Input.is_action_just_pressed("free_piece")
