class_name TestBullet extends Area3D




@export var mesh: MeshInstance3D

var properties = BulletProperties.new()
var life_time: float = 1




func  _physics_process(delta: float) -> void:
	global_position += properties.velocity * delta
	_process_life_time(delta)



func _process(delta: float) -> void:
	mesh.global_position += properties.velocity * delta
	mesh.global_position = lerp(mesh.global_position, global_position, delta * 5)




func _process_life_time(delta: float) -> void:
	life_time -= delta
	
	if life_time <= 0:
		queue_free()
