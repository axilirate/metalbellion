class_name Enemy extends RefCounted







var instance: CharacterBody3D
var attributes = Attributes.new()
var base_bio_fragmet_reward: int
var shape: Resource



func _init(type: TypeCollection.EnemyType) -> void:
	match type:
		TypeCollection.EnemyType.TEST_ENEMY:
			const SCENE_PATH: String = "res://scenes/enemies/test_enemy/test_enemy.tscn"
			var test_enemy: TestEnemy = preload(SCENE_PATH).instantiate()
			test_enemy.attributes = attributes
			attributes.max_health = 10
			attributes.health = 10
			
			instance = test_enemy
			shape = test_enemy.collision_shape.shape
			
			base_bio_fragmet_reward = 1
