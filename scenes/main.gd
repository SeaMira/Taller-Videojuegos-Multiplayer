extends Node2D


var player_scene_blue = preload("res://scenes/player_blue.tscn")
var player_scene_orange = preload("res://scenes/player_orange.tscn")
#@export var player_scene: PackedScene
@onready var players: Node2D = $Players


func _ready() -> void:
	for player_data in Game.players:
		var player = null
		
		if player_data.to_dict().role == 1: # blue
			player = player_scene_blue.instantiate()
		
		else: # orange
			player = player_scene_orange.instantiate()
			
		players.add_child(player)
		player.setup(player_data)
