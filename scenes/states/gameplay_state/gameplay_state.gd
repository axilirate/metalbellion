class_name GameplayState extends Node3D

@export var player: Player
@export var zone_holder: Node3D

var current_zone: Zone

var enemy_attribues: Array[Attributes] = []
var enemies: Array[CharacterBody3D] = []

var bullets: Array[Bullet] = []

var enemies_to_spawn: int = 10





func _process(delta: float) -> void:
	_process_zone_change()




func _physics_process(_delta: float) -> void:
	_process_enemy_spawning()
	_process_player_shooting()
	_process_enemies()
	_process_bullets()




func _process_zone_change():
	pass





func _process_enemy_spawning() -> void:
	if not is_instance_valid(current_zone.enemy_holder):
		return
	
	if not enemies_to_spawn:
		return
	
	if enemies.size() > 3:
		return
	
	_try_to_spawn_enemy()




func _process_player_shooting() -> void:
	if not Input.is_action_pressed("shoot"):
		return
	
	var bullet = Bullet.new(player.active_weapon.bullet_type)
	bullet.instance.position = player.camera.global_position
	bullet.instance.rotation = player.camera.global_rotation
	bullet.properties.velocity = -player.camera.global_transform.basis.z * 100
	add_child(bullet.instance)
	bullet.mesh.global_position = player.active_weapon.ranged_properites.barrel_marker.global_position
	bullets.push_back(bullet)






func _process_enemies() -> void:
	var enemy_indexes_to_remove: Array[int] = []
	
	for index in enemies.size():
		var enemy: CharacterBody3D = enemies[index]
		if not is_instance_valid(enemy):
			enemy_indexes_to_remove.push_back(index)
			continue
	
	
	for index in enemy_indexes_to_remove:
		enemy_attribues.pop_at(index)
		enemies.pop_at(index)





func _process_bullets() -> void:
	var bullet_indexes_to_remove: Array[int] = []
	
	
	for index in bullets.size():
		var bullet: Bullet = bullets[index]
		
		if not is_instance_valid(bullet.instance):
			bullet_indexes_to_remove.push_back(index)
			continue
		
		var overlapping_bodies = bullet.instance.get_overlapping_bodies()
		
		if overlapping_bodies.size():
			bullet.instance.queue_free()
			
			var enemy_index: int = enemies.find(overlapping_bodies.front())
			if enemy_index > -1:
				enemy_attribues[enemy_index].health -= 1
	
	
	
	for index in bullet_indexes_to_remove:
		bullets.pop_at(index)




func _try_to_spawn_enemy() -> void:
	var enemy_spawn_ray_cast: RayCast3D = preload("res://scenes/3d_nodes/enemy_spawn_ray_cast/enemy_spawn_ray_cast.tscn").instantiate()
	var enemy = Enemy.new(ObjectEnum.EnemyType.TEST_ENEMY)
	
	add_child(enemy_spawn_ray_cast)
	enemy_spawn_ray_cast.position = player.position + Vector3(randi_range(-20, 20), player.position.y + 5, randi_range(-20, 20))
	enemy_spawn_ray_cast.force_raycast_update()
	
	if not _is_spawn_valid(enemy_spawn_ray_cast, enemy.shape):
		return
	
	if not is_instance_valid(current_zone.enemy_holder):
		return
	
	var test_enemy = enemy.instance
	
	test_enemy.position = enemy_spawn_ray_cast.get_collision_point()
	current_zone.enemy_holder.add_child(test_enemy)
	enemies.push_back(test_enemy)
	enemy_attribues.push_back(test_enemy.attributes)
	enemies_to_spawn -= 1
	
	enemy_spawn_ray_cast.queue_free()






func _change_zone(zone: Zone):
	NodeUtils.clear_children(zone_holder)






func _is_spawn_valid(enemy_spawn_ray_cast: RayCast3D, shape: Resource) -> bool:
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






