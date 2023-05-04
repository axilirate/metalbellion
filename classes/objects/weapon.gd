class_name Weapon extends RefCounted





var instance: RigidBody3D
var melee_properites = MeleeWeaponProperties.new()
var ranged_properites = RangedWeaponProperties.new()
var bullet_type: TypeCollection.BulletType



func _init(type: TypeCollection.WeaponType) -> void:
	match type:
		TypeCollection.WeaponType.TEST_GUN:
			const SCENE_PATH: String = "res://scenes/guns/test_gun/test_gun.tscn"
			var test_gun: TestGun = preload(SCENE_PATH).instantiate()
			ranged_properites.barrel_marker = test_gun.barrel_marker
			ranged_properites.bullet_speed = 300
			bullet_type = TypeCollection.BulletType.TEST_BULLET
			instance = test_gun
			
			
