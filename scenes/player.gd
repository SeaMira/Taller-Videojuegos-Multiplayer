extends CharacterBody2D

const speed = 300.0
var acceleration = 3000
var pieces_on_area = []
var piece_grabbed = null
@onready var with_piece = 0

@onready var player = $"."
@onready var multiplayer_spawner = $MultiplayerSpawner
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var input_synchronizer: MultiplayerSynchronizer = $InputSynchronizer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@export var bullet_scene: PackedScene

signal fired(bullet)

var blue_piece
var orange_piece

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
	var grab_piece = input_synchronizer.grab_piece
	var free_piece = input_synchronizer.free_piece
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	move_and_slide()
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("fire"):
			fire.rpc_id(1, get_global_mouse_position())
	if Input.is_action_just_pressed("position"):
		print(get_global_mouse_position())


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

@rpc("authority", "call_local", "reliable")
func grab_piece_action():
	var max_z = -1000
	var max_z_piece = null
	if pieces_on_area.size() > 0:
		for item in pieces_on_area:
			#print(item.z_index)
			if item.z_index >= max_z:
				max_z = item.z_index
				max_z_piece = item
		
	#print(max_z)
	if max_z_piece != null:
		max_z_piece.reparent(player)
		max_z_piece.global_position.x += 20
		max_z_piece.global_position.y += 20
		piece_grabbed = max_z_piece
		
		if player.is_in_group('orange'):
			var piece_texture = piece_grabbed.get_child(0).texture
			var piece_name_splitted = piece_grabbed.name.split('_')
			var piece_index = [piece_name_splitted[1].to_int(), piece_name_splitted[2].to_int()]
			
			var w = piece_texture.get_width()/PuzzleSettings.PUZZLE_PIECES 
			var h = piece_texture.get_height()/PuzzleSettings.PUZZLE_PIECES
			orange_piece.region_enabled = true
			orange_piece.region_rect = Rect2(piece_index[1] * w, piece_index[0] * h, w, h)
			orange_piece.texture = piece_texture
			orange_piece.scale.y = 0.07
			orange_piece.scale.x = 0.07
		
		elif player.is_in_group('blue'):
			var piece_texture = piece_grabbed.get_child(0).texture
			var piece_name_splitted = piece_grabbed.name.split('_')
			var piece_index = [piece_name_splitted[1].to_int(), piece_name_splitted[2].to_int()]
			
			var w = piece_texture.get_width()/PuzzleSettings.PUZZLE_PIECES 
			var h = piece_texture.get_height()/PuzzleSettings.PUZZLE_PIECES
			blue_piece.region_enabled = true
			blue_piece.region_rect = Rect2(piece_index[1] * w, piece_index[0] * h, w, h)
			blue_piece.texture = piece_texture
			blue_piece.scale.y = 0.07
			blue_piece.scale.x = 0.07

@rpc("authority", "call_local", "reliable")
func free_piece_action():
	if piece_grabbed != null:
		print("dropped")
		piece_grabbed.reparent(get_tree().get_root().get_node("/root/Main/PiecesShow"))
		piece_grabbed = null
	
		if player.is_in_group('orange'):
			orange_piece.texture = null
		
		elif player.is_in_group('blue'):
			blue_piece.texture = null

@rpc("call_local")
func fire(mouse_pos):
	var bullet_inst = bullet_scene.instantiate()
	bullet_inst.set_velocity(global_position.direction_to(mouse_pos) * 200)
	bullet_inst.global_position = global_position
	fired.emit(bullet_inst)


