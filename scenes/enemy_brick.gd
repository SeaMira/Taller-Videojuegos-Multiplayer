extends Node2D
@onready var sprite = $Sprite2D
@onready var enemy_brick = $"."
@onready var collision_shape_2d = $CollisionShape2D

var positioned = false

var base_size = Vector2i(960, 540) 
var piece_size = base_size * (0.6/PuzzleSettings.PUZZLE_PIECES)
var delta_counter = 0
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
		delta_counter += 1
		if delta_counter >= 250:
			var projectile = load("res://scenes/projectile.tscn").instantiate()
			#projectile.scale *= 4
			projectile.set_velocity(global_position.direction_to(Vector2(0,0)) * 200)
			projectile.global_position = global_position
			add_child(projectile)
			delta_counter = 0
