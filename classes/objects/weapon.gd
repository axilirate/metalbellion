class_name Weapon





var instance: MeshInstance3D
var melee_properites = MeleeWeaponProperties.new()
var ranged_properites = RangedWeaponProperties.new()
var bullet_type: ObjectEnum.BulletType



func _init(type: ObjectEnum.WeaponType) -> void:
	match type:
		ObjectEnum.WeaponType.TEST_GUN:
			const SCENE_PATH: String = "res://scenes/guns/test_gun/test_gun.tscn"
			var test_gun: TestGun = preload(SCENE_PATH).instantiate()
			ranged_properites.barrel_marker = test_gun.barrel_marker
			bullet_type = ObjectEnum.BulletType.TEST_BULLET
			instance = test_gun
			
			
