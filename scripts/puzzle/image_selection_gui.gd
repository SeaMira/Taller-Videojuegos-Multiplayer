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

	
	
func _confirm_button_pressed():
	var viewport_size = get_viewport().size
	var target_width = viewport_size.x * 0.6
	var target_height = viewport_size.y * 0.6
	
	var texture_width = IMAGE.get_width()
	var texture_height = IMAGE.get_height()

	
	var scale_x = target_width / texture_width
	var scale_y = target_height / texture_height
	
	PuzzleSettings.PUZZLE_SCALE = Vector2(scale_x, scale_y)
	#IMAGE.set_size_override(viewport_size*0.6)
	
	PuzzleSettings.PUZZLE_IMAGE = IMAGE
	PuzzleSettings.PUZZLE_PIECES = PUZZLE_PIECES
	
	var piece_width = target_width / PUZZLE_PIECES
	var piece_height = target_height / PUZZLE_PIECES
	PuzzleSettings.pieces.clear() # Limpiar cualquier pieza existente
	for i in range(PUZZLE_PIECES):
		for j in range(PUZZLE_PIECES):
			var piece_body = RigidBody2D.new()
				
			var piece_sprite = Sprite2D.new()
			piece_sprite.texture = IMAGE
			piece_sprite.region_enabled = true
			var text_width_ppp = texture_width/PUZZLE_PIECES
			var text_height_ppp = texture_height/PUZZLE_PIECES
			piece_sprite.region_rect = Rect2(i * text_width_ppp, j * text_height_ppp, text_width_ppp, text_height_ppp)
			piece_sprite.scale = Vector2(scale_x, scale_y)

			
			piece_body.add_child(piece_sprite)
			piece_sprite.set_owner(piece_body)
			
			var collision_shape = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			
			# Ajusta la extensión de la forma de colisión para que coincida con las dimensiones escaladas del sprite
			shape.extents = Vector2(piece_width / 2, piece_height / 2) 
			collision_shape.shape = shape
			piece_body.gravity_scale = 0
			piece_body.collision_layer = 1 
			piece_body.collision_mask  = 2
			piece_body.add_child(collision_shape)

			var piece = PuzzleSettings.PuzzlePieceData.new(i, j, piece_body)
			PuzzleSettings.pieces.append(piece)
	get_tree().change_scene_to_file("res://scenes/puzzle/pieces_show.tscn")
	
	
