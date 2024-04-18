extends CharacterBody2D

const speed = 300.0
var acceleration = 3000
var pieces_on_area = []
var piece_grabbed = null
@onready var with_piece = 0

@onready var player_orange = $"."
@onready var multiplayer_spawner = $MultiplayerSpawner
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
	var grab_piece = input_synchronizer.grab_piece
	var free_piece = input_synchronizer.free_piece
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	move_and_slide()
	
	if is_bullet:
		var bullet = bullet_scene.instantiate()
		bullet.set_position(global_position)
		bullet.set_velocity(global_position.direction_to(get_global_mouse_position()) * 200)
		multiplayer_spawner.add_child(bullet, true)

	if grab_piece and not with_piece:
		grab_piece_action.rpc()
		with_piece = 1
		
	if free_piece and with_piece:
		free_piece_action.rpc()
		with_piece = 0
	
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

func _on_area_2d_body_entered(body):
	#if body.is_in_group('orange'):
	pieces_on_area.append(body)
	print(pieces_on_area)
	
func _on_area_2d_body_exited(body):
	#if body.is_in_group('orange') and body in pieces_on_area:
	pieces_on_area.erase(body)
	print(pieces_on_area)

@rpc("authority", "call_local")
func grab_piece_action():
	var max_z = -1000
	var max_z_piece = null
	for item in pieces_on_area:
		print(item.z_index)
		if item.z_index >= max_z:
			max_z = item.z_index
			max_z_piece = item
		
	print(max_z)
	max_z_piece.reparent(player_orange)
	piece_grabbed = max_z_piece

@rpc("authority", "call_local")
func free_piece_action():
	piece_grabbed.queue_free()
	piece_grabbed = null
	
		
	


