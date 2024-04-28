extends Node2D

var puzzle_scene = preload("res://scenes/puzzle/pieces_show.tscn")
var player_scene_blue = preload("res://scenes/player_blue.tscn")
var player_scene_orange = preload("res://scenes/player_orange.tscn")
#@export var player_scene: PackedScene
@onready var players: Node2D = $Players
@onready var blue_piece = $Inventory/BlueBox/BluePiece
@onready var orange_piece = $Inventory/OrangeBox/OrangePiece
@onready var bullets = $Bullets

func _ready() -> void:
	for player_data in Game.players:
		var player = null
		
		if player_data.to_dict().role == 1: # blue
			player = player_scene_blue.instantiate()
		
		else: # orange
			player = player_scene_orange.instantiate()
			
		player.blue_piece = blue_piece
		player.orange_piece = orange_piece
		players.add_child(player)
		player.setup(player_data)
		player.fired.connect(_on_player_fired)
	
	var puzzle_instance = puzzle_scene.instantiate()
	add_child(puzzle_instance)


func _on_player_fired(bullet):
	bullets.add_child(bullet, true)
