extends MarginContainer


@onready var start_game_button:Button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/StartGameButton
@onready var settings_button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/SettingsButton
@onready var exit_button = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ExitButton


func _ready():
	PuzzleSettings.clean_puzzle_settings()
	GlobalMusic.play_menu_music()
	
	start_game_button.pressed.connect(self._on_start_game_button_pressed)
	start_game_button.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	start_game_button.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	
	#start_game_button.pressed.connect(self._on_start_game_button_pressed)
	settings_button.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	settings_button.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	
	exit_button.pressed.connect(self._on_exit_game_button_pressed)
	exit_button.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	exit_button.mouse_exited.connect(GlobalMusic.on_button_hover_out)
	
	
func _on_start_game_button_pressed():
	GlobalMusic.on_button_press()
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_exit_game_button_pressed():
	GlobalMusic.on_button_press()
	get_tree().quit()
