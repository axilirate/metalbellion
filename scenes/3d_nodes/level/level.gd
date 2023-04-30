class_name Level extends Node3D


@export var player: Player
@export var enemy_holder: Node3D

var enemy_attribues: Array[Attributes] = []
var enemies: Array[CharacterBody3D] = []









func _physics_process(_delta: float) -> void:
	process_enemy_spawning()




func process_enemy_spawning() -> void:
	if enemies.size() < 10:
		try_to_spawn_enemy()




func try_to_spawn_enemy() -> void:
	var enemy := Enemy.new()
	var enemy_spawn_ray_cast: RayCast3D = preload("res://scenes/3d_nodes/enemy_spawn_ray_cast/enemy_spawn_ray_cast.tscn").instantiate()
	
	add_child(enemy_spawn_ray_cast)
	enemy_spawn_ray_cast.position = player.position + Vector3(randi_range(-20, 20), player.position.y + 5, randi_range(-20, 20))
	enemy_spawn_ray_cast.force_raycast_update()
	
	if is_spawn_valid(enemy_spawn_ray_cast, enemy.shapes[Enemy.Type.FLYING_HEAD]):
		var flying_head = enemy.scenes[Enemy.Type.FLYING_HEAD].instantiate()
		flying_head.position = enemy_spawn_ray_cast.get_collision_point()
		enemy_holder.add_child(flying_head)
		enemies.push_back(flying_head)
		enemy_attribues.push_back(flying_head.attributes)
	
	enemy_spawn_ray_cast.queue_free()







func is_spawn_valid(enemy_spawn_ray_cast: RayCast3D, shape: Resource) -> bool:
	var direct_space_state := get_world_3d().direct_space_state
	var shape_query_parameters := PhysicsShapeQueryParameters3D.new()
	
	shape_query_parameters.transform = enemy_spawn_ray_cast.transform
	shape_query_parameters.shape = shape
	
	if direct_space_state.intersect_shape(shape_query_parameters).size():
		return false
	
	if not enemy_spawn_ray_cast.is_colliding():
		return false
	
	if not enemy_spawn_ray_cast.get_collision_normal() == Vector3.UP:
		return false
	
	return true








