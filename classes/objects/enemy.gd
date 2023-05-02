class_name Enemy extends RefCounted







var instance: CharacterBody3D
var shape: Resource



func _init(type: ObjectEnum.EnemyType) -> void:
	match type:
		ObjectEnum.EnemyType.TEST_ENEMY:
			const SCENE_PATH: String = "res://scenes/enemies/test_enemy/test_enemy.tscn"
			var test_enemy: TestEnemy = preload(SCENE_PATH).instantiate()
			instance = test_enemy
			shape = test_enemy.collision_shape.shape
