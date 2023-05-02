class_name GameplayState extends Node3D

@export var player: Player
@export var zone_holder: Node3D

var current_zone: Zone

var enemy_attribues: Array[Attributes] = []
var enemies: Array[CharacterBody3D] = []

var bullets: Array[Bullet] = []

var enemies_to_spawn: int = 10





func _ready() -> void:
	_change_zone(Zone.new(ObjectEnum.ZoneType.COMBAT))



func _process(_delta: float) -> void:
	_process_zone_change()




func _physics_process(_delta: float) -> void:
	_process_enemy_spawning()
	_process_player_shooting()
	_process_enemies()
	_process_bullets()





func _process_zone_change():
	if enemies_to_spawn:
		return
	
	if enemies.size():
		return
	
	_change_zone(Zone.new(ObjectEnum.ZoneType.HUB))






func _process_enemy_spawning() -> void:
	if not is_instance_valid(current_zone.enemy_holder):
		return
	
	if not enemies_to_spawn:
		return
	
	if enemies.size() > 3:
		return
	
	var enemy_spawn_ray_cast: RayCast3D = _create_enemy_spawn_ray_cast()
	_try_to_spawn_enemy(enemy_spawn_ray_cast)
	enemy_spawn_ray_cast.queue_free()








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
	for index in range(enemies.size() - 1, -1, -1):
		var enemy: CharacterBody3D = enemies[index]
		if is_instance_valid(enemy):
			continue
		
		enemy_attribues.pop_at(index)
		enemies.pop_at(index)






func _process_bullets() -> void:
	for index in range(bullets.size() - 1, -1, -1):
		var bullet: Bullet = bullets[index]
		
		if not is_instance_valid(bullet.instance):
			bullets.pop_at(index)
			continue
		
		var overlapping_bodies = bullet.instance.get_overlapping_bodies()
		
		if not overlapping_bodies.size():
			continue
		
		var hit_body = overlapping_bodies.front()
		bullet.instance.queue_free()
		
		if not hit_body is CharacterBody3D:
			continue
		
		var enemy_index: int = enemies.find(hit_body)
		if enemy_index > -1:
			enemy_attribues[enemy_index].health -= 1






func _try_to_spawn_enemy(enemy_spawn_ray_cast: RayCast3D) -> void:
	var enemy = Enemy.new(ObjectEnum.EnemyType.TEST_ENEMY)
	
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






func _create_enemy_spawn_ray_cast() -> RayCast3D:
	var enemy_spawn_ray_cast: RayCast3D = preload("res://scenes/3d_nodes/enemy_spawn_ray_cast/enemy_spawn_ray_cast.tscn").instantiate()
	enemy_spawn_ray_cast.position = player.position + Vector3(randi_range(-20, 20), player.position.y + 5, randi_range(-20, 20))
	add_child(enemy_spawn_ray_cast)
	enemy_spawn_ray_cast.force_raycast_update()
	return enemy_spawn_ray_cast






func _change_zone(zone: Zone):
	NodeUtils.clear_children(zone_holder)
	zone_holder.add_child(zone.instance)
	current_zone = zone






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






