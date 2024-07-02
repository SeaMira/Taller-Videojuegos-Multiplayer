extends MarginContainer
@onready var resume = %Resume


func _ready():
	resume.pressed.connect(resume_when_pressed)
	hide() 

func _input(event):
	if event.is_action_pressed("pause_game"):
		sync_pause.rpc()

@rpc("any_peer", "call_local", "reliable")
func sync_pause():
	get_tree().paused = !get_tree().paused
	visible=get_tree().paused

func resume_when_pressed():
	print('resume_when_pressed_called')
	#get_tree().paused = false
	#hide()
