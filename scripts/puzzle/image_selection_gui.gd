extends MarginContainer

@onready var image_selection_gui = $"."
@onready var select_file_button = $PanelContainer/MarginContainer/VBoxContainer/select_file_button
@onready var file_dialog = $PanelContainer/MarginContainer/VBoxContainer/FileDialog
@onready var texture_rect = $PanelContainer/MarginContainer/VBoxContainer/TextureRect
@onready var option_button = $PanelContainer/MarginContainer/VBoxContainer/OptionButton
@onready var confirm_button = $PanelContainer/MarginContainer/VBoxContainer/ConfirmButton

var image_extensions = ["png", "jpg", "jpeg"]
var IMAGE = null
var PUZZLE_PIECES = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	
	### Confirm Button Setting
	confirm_button.disabled = true
	confirm_button.pressed.connect(self._confirm_button_pressed)
	
	### option selector setting
	option_button.add_item("16 x 16")
	option_button.set_item_metadata(0, 16)
	option_button.add_item("32 x 32")
	option_button.set_item_metadata(1, 32)
	option_button.add_item("64 x 64")
	option_button.set_item_metadata(2, 64)
	option_button.select(0)
	option_button.item_selected.connect(self._option_selected)
	
	### file dialog setting
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
	
	
@onready var accept_dialog = $PanelContainer/MarginContainer/VBoxContainer/AcceptDialog
	
func _file_selected(path):
	var extension = path.get_extension().to_lower()
	if extension in image_extensions:
		
		var image = Image.new()
		image.load(path)
		
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		IMAGE = image_texture
		
		texture_rect.texture = image_texture
		confirm_button.disabled = false
	else:
		IMAGE = null
		texture_rect.texture = null
		confirm_button.disabled = true
		accept_dialog.visible = !accept_dialog.visible
		
		
func _option_selected(index):
	var pieces_amount = option_button.get_item_metadata(index)
	PUZZLE_PIECES = pieces_amount
	print("_option_pressed: ", pieces_amount) 
	
	
func _confirm_button_pressed():
	PuzzleSettings.PUZZLE_IMAGE = IMAGE
	PuzzleSettings.PUZZLE_PIECES = PUZZLE_PIECES
	
	var piece_width = IMAGE.get_width() / PUZZLE_PIECES
	var piece_height = IMAGE.get_height() / PUZZLE_PIECES
	PuzzleSettings.pieces.clear() # Limpiar cualquier pieza existente
	for i in range(PUZZLE_PIECES):
		for j in range(PUZZLE_PIECES):
			var piece_data = Sprite2D.new()
			piece_data.texture = IMAGE
			piece_data.region_enabled = true
			piece_data.region_rect = Rect2(i * piece_width, j * piece_height, piece_width, piece_height)
			var piece = PuzzleSettings.PuzzlePieceData.new(i, j, piece_data)
			# En lugar de añadir el sprite a la escena, lo almacenamos
			PuzzleSettings.pieces.append(piece)
	get_tree().change_scene_to_file("res://scenes/puzzle/pieces_show.tscn")
	
	
