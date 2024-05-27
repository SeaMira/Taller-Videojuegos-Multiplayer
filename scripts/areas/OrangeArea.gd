extends Area2D

func _on_body_exited(body):
	if is_multiplayer_authority() and body.is_in_group('orange'):
		if body.is_in_group('bullet'):
			body.reduce_durability.rpc()
		else:
			body.off_shoot_plat.rpc()


func _on_body_entered(body):
	if is_multiplayer_authority() and body.is_in_group('orange'):
		if body.is_in_group('bullet'):
			body.check_durability.rpc()
		else:
			body.on_shoot_plat.rpc()
