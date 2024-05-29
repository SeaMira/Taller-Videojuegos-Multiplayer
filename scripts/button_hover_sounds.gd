extends Button

@onready var button = $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	button.mouse_entered.connect(GlobalMusic.on_button_hover_in)
	button.mouse_exited.connect(GlobalMusic.on_button_hover_in)


