extends Node2D

@onready var to_menu_timer = $ToMenuTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalMusic.play_game_over_music()
	to_menu_timer.one_shot = true
	#game_timer.autostart = true
	to_menu_timer.timeout.connect(_on_GameTimer_timeout)
	to_menu_timer.start(10) #* PuzzleSettings.PUZZLE_PIECES * 60)


func _on_GameTimer_timeout():
	get_tree().change_scene_to_file("res://scenes/menu/StartingMenu.tscn")
