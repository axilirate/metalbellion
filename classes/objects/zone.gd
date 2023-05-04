class_name Zone extends RefCounted






var instance: Node3D
var enemy_nodes: Node3D
var player_spawn_point_marker: Marker3D
var enter_combat_zone_interactable: EnterCombatZoneInteractable
var equipment_interactable: EquipmentInteractable




func _init(type: TypeCollection.ZoneType) -> void:
	match type:
		TypeCollection.ZoneType.COMBAT:
			var combat_zone = preload("res://scenes/zones/combat_zone/combat_zone.tscn").instantiate()
			instance = combat_zone
			
			enemy_nodes = combat_zone.enemy_nodes
			player_spawn_point_marker = combat_zone.player_spawn_point_marker
			
			
		TypeCollection.ZoneType.HUB:
			var hub_zone = preload("res://scenes/zones/hub_zone/hub_zone.tscn").instantiate()
			instance = hub_zone
			player_spawn_point_marker = hub_zone.player_spawn_point_marker
			
			enter_combat_zone_interactable = hub_zone.enter_combat_zone_interactable
			equipment_interactable = hub_zone.equipment_interactable
			
