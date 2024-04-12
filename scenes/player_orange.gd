extends CharacterBody2D

const speed = 300.0
var acceleration = 3000

@onready var player_orange = $"."
@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var input_synchronizer: MultiplayerSynchronizer = $InputSynchronizer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@export var bullet_scene: PackedScene

@export var score = 1 :
	set(value):
		score = value
		Debug.sprint("Player %s score %d" % [name, score])

func _ready() -> void:
	animation_tree.active = true

func setup(player_data: Statics.PlayerData):
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
	multiplayer_spawner.set_multiplayer_authority(player_data.id)
	multiplayer_synchronizer.set_multiplayer_authority(player_data.id)

func _physics_process(delta):
	var move_input = input_synchronizer.move_input
	var target_velocity = move_input * speed
	var is_bullet = input_synchronizer.is_bullet
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	move_and_slide()
	
	if is_bullet:
		var bullet = bullet_scene.instantiate()
		bullet.set_position(global_position)
		multiplayer_spawner.add_child(bullet, true)
	
	if velocity.x > 0:
		playback.travel("go_right")
	elif velocity.x < 0:
		playback.travel("go_left")
	elif velocity.y < 0:
		playback.travel("go_up")
	elif velocity.y > 0:
		playback.travel("go_down")
	else:
		playback.travel("idle")
	
@rpc
func send_data(pos: Vector2, vel: Vector2):
	global_position = lerp(global_position, pos, 0.75)
	velocity = lerp(velocity, vel, 0.75)
	
