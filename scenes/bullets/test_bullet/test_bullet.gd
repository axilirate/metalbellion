class_name TestBullet extends Area3D




@export var mesh: MeshInstance3D

var properties = BulletProperties.new()





func  _physics_process(delta: float) -> void:
	global_position += properties.velocity * properties.speed * delta
	mesh.global_position = global_position
