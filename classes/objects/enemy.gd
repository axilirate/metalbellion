class_name Enemy extends RefCounted







var instance: CharacterBody3D
var shape: Resource



func _init(type: TypeCollection.EnemyType) -> void:
	match type:
		TypeCollection.EnemyType.TEST_ENEMY:
			const SCENE_PATH: String = "res://scenes/enemies/test_enemy/test_enemy.tscn"
			var test_enemy: TestEnemy = preload(SCENE_PATH).instantiate()
			test_enemy.attributes.max_health = 10
			test_enemy.attributes.health = 10
			
			instance = test_enemy
			shape = test_enemy.collision_shape.shape
