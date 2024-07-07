extends MarginContainer


@onready var start_game_button:Button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/StartGameButton
@onready var settings_button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/SettingsButton
@onready var exit_button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ExitButton
@onready var v_box_container = $VBoxContainer
@onready var settings = $Settings
@onready var back = $Back
@onready var how_to_play = $HowToPlay
@onready var how_to_play_button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HowToPlayButton
@onready var back_2 = $HowToPlay/Back2
@onready var back_3 = $Credits/Back
@onready var credits = $Credits
@onready var credits_button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/CreditsButton




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
	
	credits_button.pressed.connect(self._on_credits_button_pressed)
	credits_button.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	credits_button.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	back_3.pressed.connect(self._back_to_main_menu)
	back_3.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	back_3.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	
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
	GlobalMusic.on_button_press()
	settings.visible = true
	v_box_container.visible = false
	back.visible = true

func _on_how_to_play_button_pressed():
	GlobalMusic.on_button_press()
	how_to_play.visible = true
	v_box_container.visible = false
	back_2.visible = true
	
func _on_exit_game_button_pressed():
	GlobalMusic.on_button_press()
	get_tree().quit()

func _on_credits_button_pressed():
	GlobalMusic.on_button_press()
	v_box_container.visible = false
	credits.visible = true
	back_3.visible = true

func _back_to_main_menu():
	settings.visible = false
	how_to_play.visible = false
	v_box_container.visible = true
	credits.visible = false
	back.visible = false
	back_2.visible = false
	back_3.visible = false
