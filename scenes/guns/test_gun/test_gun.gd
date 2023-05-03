class_name TestGun extends RigidBody3D


@export var barrel_marker: Marker3D
@export var mesh: MeshInstance3D




func _process(delta: float) -> void:
	_process_mesh(delta)




func _process_mesh(delta: float) -> void:
	var current_rot: Quaternion = mesh.global_transform.basis.get_rotation_quaternion()
	var target_rot: Quaternion = global_transform.basis.get_rotation_quaternion()
	var smooth_rot = lerp(current_rot, target_rot, delta * 60)
	mesh.global_position = lerp(mesh.global_position, global_position, delta * 30)
	mesh.global_transform.basis = Basis(smooth_rot)
