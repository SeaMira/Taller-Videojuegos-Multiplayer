extends MarginContainer


@onready var start_game_button :Button = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/StartGameButton
@onready var exit_button = $HBoxContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ExitButton


func _ready():
	start_game_button.pressed.connect(self._on_start_game_button_pressed)
	
func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_exit_game_button_pressed():
	get_tree().quit()
