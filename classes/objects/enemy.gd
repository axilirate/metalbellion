class_name Enemy extends RefCounted


enum Type {
	TEST_ENEMY
	}


const TEST_ENEMY_SCENE_PATH: String = "res://scenes/enemies/test_enemy/test_enemy.tscn"


var scenes: Array[PackedScene] = []
var attributes: Array[Attributes] = []
var shapes: Array[Resource] = []




func _init() -> void:
	var test_enemy: TestEnemy = preload(TEST_ENEMY_SCENE_PATH).instantiate()
	
	scenes.resize(Type.size())
	attributes.resize(Type.size())
	shapes.resize(Type.size())
	
	
	scenes[Type.TEST_ENEMY] = preload(TEST_ENEMY_SCENE_PATH)
	
	
	attributes[Type.TEST_ENEMY] = test_enemy.attributes
	shapes[Type.TEST_ENEMY] = test_enemy.collision_shape.shape
