class_name TestBullet extends RigidBody3D


@export var mesh: MeshInstance3D


var properties: BulletProperties
var life_time: float = 1




func  _physics_process(delta: float) -> void:
	_process_life_time(delta)


func _process(delta: float) -> void:
	_process_mesh(delta)



func _process_mesh(delta: float) -> void:
	var current_rot: Quaternion = mesh.global_transform.basis.get_rotation_quaternion()
	var target_rot: Quaternion = global_transform.basis.get_rotation_quaternion()
	var smooth_rot = lerp(current_rot, target_rot, delta * 60)
	mesh.global_position = lerp(mesh.global_position, global_position, delta * 60)
	mesh.global_transform.basis = Basis(smooth_rot)




func _process_life_time(delta: float) -> void:
	life_time -= delta
	
	if life_time <= 0:
		queue_free()
