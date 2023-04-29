class_name PlayerBody extends CharacterBody3D











func _physics_process(delta: float) -> void:
	process_velocity()
	move_and_slide()




func _input(event: InputEvent) -> void:
	process_look_rotation(event)




func process_velocity() -> void:
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")




func process_look_rotation(event: InputEvent) -> void:
	pass
