class_name Bullet





var instance: Area3D
var properties: BulletProperties


func _init(type: GlobalEnum.BulletType) -> void:
	match type:
		GlobalEnum.BulletType.TEST_BULLET:
			const SCENE_PATH: String = "res://scenes/bullets/test_bullet/test_bullet.tscn"
			var test_bullet: TestBullet = preload(SCENE_PATH).instantiate()
			instance = test_bullet
			properties = test_bullet.properties
