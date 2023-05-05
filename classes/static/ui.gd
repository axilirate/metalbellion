class_name UI








static func is_hovered(control: Control):
	if not control.is_visible_in_tree():
		return false
	
	return control.get_global_rect().has_point(control.get_global_mouse_position())
