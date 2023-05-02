class_name Bullet extends RefCounted





var instance: Area3D
var mesh: MeshInstance3D
var properties: BulletProperties


func _init(type: ObjectEnum.BulletType) -> void:
	match type:
		ObjectEnum.BulletType.TEST_BULLET:
			const SCENE_PATH: String = "res://scenes/bullets/test_bullet/test_bullet.tscn"
			var test_bullet: TestBullet = preload(SCENE_PATH).instantiate()
			instance = test_bullet
			mesh = test_bullet.mesh
			properties = test_bullet.properties
