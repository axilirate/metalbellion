class_name Weapon




enum Type {
	TEST_GUN
	}



var instance: MeshInstance3D
var melee_properites = MeleeWeaponProperties.new()
var ranged_properites = RangedWeaponProperties.new()



func _init(type: Type) -> void:
	match type:
		Type.TEST_GUN:
			const SCENE_PATH: String = "res://scenes/guns/test_gun/test_gun.tscn"
			var test_gun: TestGun = preload(SCENE_PATH).instantiate()
			ranged_properites.barrel_marker = test_gun.barrel_marker
			instance = test_gun
			
