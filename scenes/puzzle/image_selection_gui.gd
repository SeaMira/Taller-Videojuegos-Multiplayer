extends MarginContainer

@onready var image_selection_gui = $"."
@onready var select_file_button = $PanelContainer/MarginContainer/VBoxContainer/select_file_button
@onready var file_dialog = $PanelContainer/MarginContainer/VBoxContainer/FileDialog
@onready var texture_rect = $PanelContainer/MarginContainer/VBoxContainer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	file_dialog.file_mode = 0
	file_dialog.add_filter("*.png, *.jpg, *.jpeg", "Images")
	select_file_button.pressed.connect(self._button_pressed.bind("some_variable_or_value"))
	file_dialog.file_selected.connect(self._file_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _button_pressed(arg):
	file_dialog.visible = !file_dialog.visible
	print("_button_pressed: ", arg) 
	
func _file_selected(path):
	var image = Image.new()
	image.load(path)
	
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	
	texture_rect.texture = image_texture
	pass
