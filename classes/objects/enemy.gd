class_name Enemy extends RefCounted


enum Type {
	FLYING_HEAD
	}


const FLYING_HEAD_SCENE_PATH: String = "res://scenes/enemies/flying_head/flying_head.tscn"


var scenes: Array[PackedScene] = []
var attributes: Array[Attributes] = []
var shapes: Array[Resource] = []




func _init() -> void:
	var flying_head: FlyingHead = preload(FLYING_HEAD_SCENE_PATH).instantiate()
	
	scenes.resize(Type.size())
	attributes.resize(Type.size())
	shapes.resize(Type.size())
	
	
	scenes[Type.FLYING_HEAD] = preload(FLYING_HEAD_SCENE_PATH)
	
	
	attributes[Type.FLYING_HEAD] = flying_head.attributes
	shapes[Type.FLYING_HEAD] = flying_head.collision_shape.shape
