extends Control

@onready var global_slider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Global/GlobalSlider
@onready var music_slider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Music/MusicSlider
@onready var sfx_slider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/SFX/SFXSlider
@onready var menu_slider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Menu/MenuSlider


func _ready():
	# Conectar las señales de los sliders
	global_slider.value_changed.connect(self._on_MasterSlider_value_changed)
	music_slider.value_changed.connect(self._on_MusicSlider_value_changed)
	sfx_slider.value_changed.connect(self._on_SFXSlider_value_changed)
	menu_slider.value_changed.connect(self._on_MenuSlider_value_changed)
	
	global_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("music")))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx")))
	menu_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("menu")))
	


func _on_MasterSlider_value_changed(value):
	#set_linear_db("Master", value / global_slider.max_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))


func _on_MusicSlider_value_changed(value):
	#set_linear_db("music", value / music_slider.max_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear_to_db(value))

func _on_SFXSlider_value_changed(value):
	#set_linear_db("sfx", value / sfx_slider.max_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), linear_to_db(value))

func _on_MenuSlider_value_changed(value):
	#set_linear_db("menu", value / menu_slider.max_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("menu"), linear_to_db(value))

func get_linear_db(bus_name : String) -> float:
	assert(AudioServer.get_bus_index(bus_name) != -1, "Audiobus with the name " + bus_name + " does not exist.")
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name)))


func set_linear_db(bus_name : String, linear_db : float) -> void:
	assert(AudioServer.get_bus_index(bus_name) != -1, "Audiobus with the name " + bus_name + " does not exist.")
	linear_db = clamp(linear_db, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(linear_db*5))
