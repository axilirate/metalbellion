class_name Player extends CharacterBody3D

@export var weapon_holder: Node3D
@export var camera_target: Marker3D
@export var camera: Camera3D

var attributes := Attributes.new()
var active_weapon: Weapon

var speed: float = 10
var jump_power: float = 10
var mouse_sensitivity: float = 0.005









func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	equip_weapon(Weapon.new(ObjectEnum.WeaponType.TEST_GUN))



func _process(delta: float) -> void:
	process_camera(delta)




func _physics_process(_delta: float) -> void:
	process_velocity()
	move_and_slide()




func _input(event: InputEvent) -> void:
	process_camera_target_look_rotation(event)
	process_look_rotation(event)
	



func process_camera(delta) -> void:
	var current_rot = Quaternion(camera.global_transform.basis.get_rotation_quaternion())
	var target_rot = Quaternion(camera_target.global_transform.basis.get_rotation_quaternion())
	var smooth_rot = lerp(current_rot, target_rot, delta * 60)
	camera.global_position = lerp(camera.global_position, camera_target.global_position, delta * 20)
	camera.global_transform.basis = Basis(smooth_rot)





func process_velocity() -> void:
	var input_dir: Vector2 = Input.get_vector("move_right", "move_left", "move_forward", "move_backward")
	var move_dir: Vector3 = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, rotation.y)
	velocity = move_dir * speed




func process_camera_target_look_rotation(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_target.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_target.rotation.x = clamp(camera_target.rotation.x, deg_to_rad(-89), deg_to_rad(89))




func process_look_rotation(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)





func equip_weapon(weapon: Weapon) -> void:
	NodeUtils.clear_children(weapon_holder)
	active_weapon = weapon
	weapon_holder.add_child(weapon.instance)



