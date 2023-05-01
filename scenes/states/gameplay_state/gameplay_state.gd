class_name GameplayState extends Node3D

@export var player: Player
@export var enemy_holder: Node3D

var enemy_attribues: Array[Attributes] = []
var enemies: Array[CharacterBody3D] = []

var player_shot_bullets: Array[Area3D] = []





func _physics_process(_delta: float) -> void:
	process_enemy_spawning()
	process_player_shooting()



func process_enemy_spawning() -> void:
	if enemies.size() < 10:
		try_to_spawn_enemy()






func process_player_shooting():
	if not Input.is_action_pressed("shoot"):
		return
	
	player.camera.global_rotation
	print("?")





func try_to_spawn_enemy() -> void:
	var enemy_spawn_ray_cast: RayCast3D = preload("res://scenes/3d_nodes/enemy_spawn_ray_cast/enemy_spawn_ray_cast.tscn").instantiate()
	var enemy = Enemy.new(GlobalEnum.EnemyType.TEST_ENEMY)
	
	add_child(enemy_spawn_ray_cast)
	enemy_spawn_ray_cast.position = player.position + Vector3(randi_range(-20, 20), player.position.y + 5, randi_range(-20, 20))
	enemy_spawn_ray_cast.force_raycast_update()
	
	if is_spawn_valid(enemy_spawn_ray_cast, enemy.shape):
		var test_enemy = enemy.instance
		
		test_enemy.position = enemy_spawn_ray_cast.get_collision_point()
		enemy_holder.add_child(test_enemy)
		enemies.push_back(test_enemy)
		enemy_attribues.push_back(test_enemy.attributes)
	
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
