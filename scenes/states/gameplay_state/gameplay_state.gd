class_name GameplayState extends Node3D

@export var player: Player
@export var zone_holder: Node3D

var current_zone: Zone


var enemy_bodies: Array[CharacterBody3D] = []
var enemies: Array[Enemy] = []

var bullets: Array[Bullet] = []

var enemies_to_spawn: int = 5





func _ready() -> void:
	_change_zone(Zone.new(TypeCollection.ZoneType.COMBAT))







func _process(delta: float) -> void:
	_process_upgrade_window()






func _physics_process(_delta: float) -> void:
	_process_enemy_spawning()
	_process_player_shooting()
	_process_enemies()
	_process_bullets()









	














func _process_upgrade_window() -> void:
	player.canvas_layer.upgrade_window.hide()
	
	if enemies_to_spawn:
		return
	
	if enemy_bodies.size():
		return
	
	player.canvas_layer.upgrade_window.show()


















func _process_enemy_spawning() -> void:
	if not is_instance_valid(current_zone.enemy_nodes):
		return
	
	if not enemies_to_spawn:
		return
	
	if enemy_bodies.size() > 3:
		return
	
	var enemy_spawn_ray_cast: RayCast3D = _create_enemy_spawn_ray_cast()
	_try_to_spawn_enemy(enemy_spawn_ray_cast)
	enemy_spawn_ray_cast.queue_free()
















func _process_player_shooting() -> void:
	if not Input.is_action_pressed("shoot"):
		return
	
	if not is_instance_valid(player.active_weapon.instance):
		return
	
	var bullet = Bullet.new(player.active_weapon.bullet_type)
	bullet.instance.position = player.active_weapon.ranged_properites.barrel_marker.global_position
	bullet.instance.rotation = player.active_weapon.ranged_properites.barrel_marker.global_rotation
	bullet.instance.linear_velocity = -player.camera.global_transform.basis.z * player.active_weapon.ranged_properites.bullet_speed
	bullet.properties.last_frame_global_pos = player.active_weapon.ranged_properites.barrel_marker.global_position
	add_child(bullet.instance)
	bullet.mesh_instance.global_position = player.active_weapon.ranged_properites.barrel_marker.global_position
	bullets.push_back(bullet)















func _process_enemies() -> void:
	for index in range(enemy_bodies.size() - 1, -1, -1):
		var enemy: CharacterBody3D = enemy_bodies[index]
		if is_instance_valid(enemy):
			continue
		
		enemies.pop_at(index)
		enemy_bodies.pop_at(index)

















func _process_bullets() -> void:
	for index in range(bullets.size() - 1, -1, -1):
		var bullet: Bullet = bullets[index]
		
		if not is_instance_valid(bullet.instance):
			bullets.pop_at(index)
			continue
		
		
		var direct_space_state := get_world_3d().direct_space_state
		var ray_query_parameters := PhysicsRayQueryParameters3D.new()
		
		ray_query_parameters.from = bullet.instance.global_position
		ray_query_parameters.to = bullet.properties.last_frame_global_pos
		
		
		
		var ray_collision: Dictionary = direct_space_state.intersect_ray(ray_query_parameters)
		
		bullet.properties.last_frame_global_pos = bullet.instance.global_position
		
		
		if not ray_collision.size():
			continue
		
		
		var hit_body = ray_collision["collider"]
		
		if hit_body is CharacterBody3D:
			var enemy_index: int = enemy_bodies.find(hit_body)
			if enemy_index > -1:
				_damage_enemy(enemies[enemy_index], 1)
		
		bullet.instance.queue_free()













func _try_to_spawn_enemy(enemy_spawn_ray_cast: RayCast3D) -> void:
	var enemy = Enemy.new(TypeCollection.EnemyType.TEST_ENEMY)
	
	if not _is_spawn_valid(enemy_spawn_ray_cast, enemy.shape):
		return
	
	if not is_instance_valid(current_zone.enemy_nodes):
		return
	
	var test_enemy = enemy.instance
	test_enemy.position = enemy_spawn_ray_cast.get_collision_point()
	current_zone.enemy_nodes.add_child(test_enemy)
	enemy_bodies.push_back(test_enemy)
	enemies.push_back(enemy)
	enemies_to_spawn -= 1














func _create_enemy_spawn_ray_cast() -> RayCast3D:
	var enemy_spawn_ray_cast: RayCast3D = preload("res://scenes/3d_nodes/enemy_spawn_ray_cast/enemy_spawn_ray_cast.tscn").instantiate()
	enemy_spawn_ray_cast.position = player.position + Vector3(randi_range(-20, 20), player.position.y + 5, randi_range(-20, 20))
	add_child(enemy_spawn_ray_cast)
	enemy_spawn_ray_cast.force_raycast_update()
	return enemy_spawn_ray_cast











func _damage_enemy(enemy: Enemy, damage: int) -> void:
	enemy.attributes.health -= damage








func _change_zone(zone: Zone):
	NodeUtils.clear_children(zone_holder)
	zone_holder.add_child(zone.instance)
	current_zone = zone
	
	if is_instance_valid(zone.enemy_nodes):
		enemies_to_spawn = 10


















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






