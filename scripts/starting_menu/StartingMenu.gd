extends MarginContainer


@onready var start_game_button:Button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/StartGameButton
@onready var settings_button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/SettingsButton
@onready var exit_button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ExitButton
@onready var v_box_container = $VBoxContainer
@onready var settings = $Settings
@onready var back = $Back
@onready var how_to_play = $HowToPlay
@onready var how_to_play_button = $HowToPlayButton
@onready var back_2 = $HowToPlay/Back2




func _ready():
	multiplayer.multiplayer_peer.close()
	Game.players = []
	settings.visible = false
	back.visible = false
	how_to_play.visible = false
	PuzzleSettings.clean_puzzle_settings()
	GlobalMusic.play_menu_music()
	
	start_game_button.pressed.connect(self._on_start_game_button_pressed)
	start_game_button.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	start_game_button.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	
	settings_button.pressed.connect(self._on_settings_button_pressed)
	settings_button.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	settings_button.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	
	how_to_play_button.pressed.connect(self._on_how_to_play_button_pressed)
	how_to_play_button.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	how_to_play_button.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	back_2.pressed.connect(self._back_to_main_menu)
	back_2.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	back_2.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	
	exit_button.pressed.connect(self._on_exit_game_button_pressed)
	exit_button.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	exit_button.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	
	back.pressed.connect(self._back_to_main_menu)
	back.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	back.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	
	
func _on_start_game_button_pressed():
	GlobalMusic.on_button_press()
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_settings_button_pressed():
	settings.visible = true
	v_box_container.visible = false
	back.visible = true

func _on_how_to_play_button_pressed():
	how_to_play.visible = true
	v_box_container.visible = false
	
func _on_exit_game_button_pressed():
	GlobalMusic.on_button_press()
	get_tree().quit()

func _back_to_main_menu():
	settings.visible = false
	how_to_play.visible = false
	v_box_container.visible = true
	back.visible = false
