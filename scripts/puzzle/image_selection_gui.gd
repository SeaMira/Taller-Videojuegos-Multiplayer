extends MarginContainer

@onready var image_selection_gui = $"."
@onready var select_file_button = $PanelContainer/MarginContainer/VBoxContainer/select_file_button
@onready var file_dialog = $PanelContainer/MarginContainer/VBoxContainer/FileDialog
@onready var texture_rect = $PanelContainer/MarginContainer/VBoxContainer/TextureRect
@onready var option_button = $PanelContainer/MarginContainer/VBoxContainer/OptionButton
@onready var confirm_button = $PanelContainer/MarginContainer/VBoxContainer/ConfirmButton
@onready var cancel_button = $PanelContainer/MarginContainer/VBoxContainer/CancelButton

var image_extensions = ["png", "jpg"]
var IMAGE = null
var PUZZLE_PIECES = 16

var status = {  }
var images = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_initial_status.rpc()
	set_multiplayer_authority(multiplayer.get_unique_id())
	### Confirm Button Setting
	confirm_button.disabled = true
	confirm_button.pressed.connect(self._confirm_button_pressed)
	cancel_button.pressed.connect(self._cancel_button_pressed)
	
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
	file_dialog.add_filter("*.png, *.jpg", "Images")
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
		var data = image.data.duplicate()
		data.format2 = image.get_format()
		save_image.rpc(multiplayer.get_unique_id(), data, extension)
		print(images.keys())
		
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
		
@rpc("reliable", "any_peer", "call_local")
func save_image(id, image_data, extension):
	
	images[id] = [image_data, extension]
		
func _option_selected(index):
	var pieces_amount = option_button.get_item_metadata(index)
	PUZZLE_PIECES = pieces_amount
	print("piezas ", pieces_amount)
	#change_status.rpc(multiplayer.get_unique_id())

	
	
func _confirm_button_pressed():
	cancel_button.visible = true
	confirm_button.visible = false
	player_ready.rpc_id(1, multiplayer.get_unique_id())
	
	
func _cancel_button_pressed():
	confirm_button.visible = true
	cancel_button.visible = false
	change_status.rpc_id(1, multiplayer.get_unique_id())
	
@rpc("reliable", "any_peer", "call_local")
func player_ready(id: int):
	if multiplayer.is_server():
		status[id] = !status[id]
		var all_ok = true
		for ok in status.values():
			all_ok = all_ok and ok
		if all_ok:
			var key = choose_random_key()
			starting_game.rpc(true, key)
		else:
			starting_game.rpc(false)
			
			
@rpc("any_peer", "call_local", "reliable")
func starting_game(value: bool, key):
	if value:
		setting_puzzle.rpc(key)
		start_game.rpc()
	else:
		print("a")

func choose_random_key():
# Obtiene todas las llaves del diccionario como un arreglo
	var llaves = images.keys()
	# Elige un índice aleatorio del arreglo de llaves
	var indice_aleatorio = randi() % llaves.size()
	# Retorna la llave elegida aleatoriamente
	return llaves[indice_aleatorio]

@rpc("any_peer", "call_local", "reliable")
func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
	
@rpc("any_peer", "call_local", "reliable")
func set_initial_status():
	for player in Game.players:
		status[player.id] = false
		
@rpc("any_peer","call_local", "reliable")
func change_status(id):
	if multiplayer.is_server():
		status[id] = !status[id]
	print(status)
	
@rpc("any_peer", "call_local", "reliable")
func setting_puzzle(image_player):
	
	#var image_player = choose_random_key()
	var image_and_extension = images[image_player]
	#print(image_and_extension[0])
	var data = image_and_extension[0]
	print(data.format2)
	var image = Image.create_from_data(data.width, data.height, data.mipmaps, data.format2, data.data )
	#if image_and_extension[1] == "jpg":
		#image.load_jpg_from_buffer(image_and_extension[0])
	#elif image_and_extension[1] == "png":
		#image.load_png_from_buffer(image_and_extension[0])
	
		
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	#IMAGE = image_texture
	
	var viewport_size = get_viewport().size
	var target_width = viewport_size.x * 0.6
	var target_height = viewport_size.y * 0.6
	print(viewport_size, target_width, target_height)
	var texture_width = image_texture.get_width()
	var texture_height = image_texture.get_height()
	print(texture_width, texture_height)
	
	var scale_x = target_width / texture_width
	var scale_y = target_height / texture_height
	
	PuzzleSettings.PUZZLE_SCALE = Vector2(scale_x, scale_y)
	#IMAGE.set_size_override(viewport_size*0.6)
	
	PuzzleSettings.PUZZLE_IMAGE = image_texture
	PuzzleSettings.PUZZLE_PIECES = PUZZLE_PIECES
	
	var piece_width = target_width / PUZZLE_PIECES
	var piece_height = target_height / PUZZLE_PIECES
	PuzzleSettings.pieces.clear() # Limpiar cualquier pieza existente
	for i in range(PUZZLE_PIECES):
		for j in range(PUZZLE_PIECES):
			var piece_body = RigidBody2D.new()
				
			var piece_sprite = Sprite2D.new()
			piece_sprite.texture = image_texture
			piece_sprite.region_enabled = true
			var text_width_ppp = texture_width/PUZZLE_PIECES
			var text_height_ppp = texture_height/PUZZLE_PIECES
			piece_sprite.region_rect = Rect2(i * text_width_ppp, j * text_height_ppp, text_width_ppp, text_height_ppp)
			piece_sprite.scale = Vector2(scale_x, scale_y)
			
			var contorno_sprite = piece_sprite.duplicate()
			contorno_sprite.modulate = Color(0, 0, 0, 1)  # Cambia el color a negro para el contorno
			contorno_sprite.scale *= 1.05
			
			piece_body.add_child(piece_sprite)
			piece_body.add_child(contorno_sprite)
			piece_body.move_child(contorno_sprite, 0)
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

