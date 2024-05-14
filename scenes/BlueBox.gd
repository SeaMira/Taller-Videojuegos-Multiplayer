extends Sprite2D
@onready var box = $"."
@onready var orange_box = $"../OrangeBox"
@onready var viewport = get_viewport()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var box_scale_x = (viewport.size.x/5) / box.texture.get_width()
	#var  box_scale_y = (viewport.size.x/5) / box.texture.get_height()
	#box.scale.x = box_scale_x
	#box.scale.y = box_scale_y
	#
	##box.global_position.x += (viewport.size.x/5)/2
	##box.global_position.y += (viewport.size.x/5)/2
	#
	##orange_box.global_position.y = (viewport.size.y - box.texture.get_height()/2 * box_scale_y)
	#print('orange_box', orange_box.global_position.y)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
