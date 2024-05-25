extends Node2D
@onready var sprite = $Sprite2D
@onready var enemy_brick = $"."
@onready var collision_shape_2d = $CollisionShape2D

var positioned = false

var base_size = Vector2i(960, 540) 
var piece_size = base_size * (0.6/PuzzleSettings.PUZZLE_PIECES)
var delta_counter = 0
var shot_intervals = [0, 3, 6, 9]  
var directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]  

func _ready():
	var new_brick_size = piece_size / 2
	var brick_texture_size = sprite.texture.get_size()
	var scale_x = new_brick_size.x / brick_texture_size.x
	var scale_y = new_brick_size.y / brick_texture_size.y
	var brick_scale_factor = Vector2(scale_x, scale_y)
	enemy_brick.scale = brick_scale_factor
	sprite.centered = false
	collision_shape_2d.position = Vector2(sprite.texture.get_size() * sprite.scale / 2)

func _process(delta):
	if positioned:
		delta_counter += delta
		if delta_counter >= 5:
			delta_counter = 0
			var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
			for direction in directions:
				var projectile = load("res://scenes/projectile.tscn").instantiate()
				projectile.set_velocity(direction * 200)
				projectile.global_position = global_position
				add_child(projectile)
