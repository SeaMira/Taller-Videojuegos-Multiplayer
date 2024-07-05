extends PanelContainer
@onready var resume_button = %ResumeButton
@onready var settings_button = $MarginContainer/VBoxContainer/SettingsButton
@onready var exit_button = $MarginContainer/VBoxContainer/ExitButton
@onready var v_box_container = $".."
@onready var settings = $"../../Settings"
@onready var back = $"../../Back"


var status = {}

func _ready():
	set_initial_status.rpc()
	settings.visible = false
	back.visible = false
	resume_button.pressed.connect(self.resume_on_pressed)
	settings_button.pressed.connect(self.settigns_on_pressed)
	exit_button.pressed.connect(self.get_to_main_menu)
	back.pressed.connect(self.back_on_pressed)
	hide()

func _input(event):
	if event.is_action_pressed("pause_game"):
		set_initial_status.rpc()
		sync_pause.rpc()

@rpc("any_peer", "call_local", "reliable")
func sync_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused

@rpc("any_peer", "call_local", "reliable")
func set_initial_status():
	for player in Game.players:
		status[player.id] = false

func resume_on_pressed():
	player_ready.rpc_id(1, multiplayer.get_unique_id())

@rpc("reliable", "any_peer", "call_local")
func player_ready(id: int):
	if multiplayer.is_server():
		status[id] = !status[id]
		var all_ok = true
		for ok in status.values():
			all_ok = all_ok and ok
		if all_ok:
			resume_game.rpc(true)
		else:
			resume_game.rpc(false)

@rpc("any_peer", "call_local", "reliable")
func resume_game(value: bool):
	if value:
		resume_scene.rpc()
	

@rpc("any_peer", "call_local", "reliable")
func resume_scene():
	get_tree().paused = false
	visible = false

func settigns_on_pressed():
	v_box_container.visible = false
	settings.visible = true
	back.visible = true


func back_on_pressed():
	v_box_container.visible = true
	settings.visible = false
	back.visible = false
	
	
func get_to_main_menu():
	exit_on_pressed.rpc()
	
@rpc("any_peer", "call_local", "reliable")
func exit_on_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/StartingMenu.tscn")
