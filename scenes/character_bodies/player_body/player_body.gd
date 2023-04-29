class_name PlayerBody extends CharacterBody3D


@export var camera_target: Marker3D
@export var camera: Camera3D

var speed: float = 10




func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _process(delta: float) -> void:
	process_camera(delta)




func _physics_process(delta: float) -> void:
	process_velocity()
	move_and_slide()




func _input(event: InputEvent) -> void:
	process_camera_target_look_rotation(event)
	process_look_rotation(event)
	







func process_camera(delta) -> void:
	camera.global_position = lerp(camera.global_position, camera_target.global_position, delta * 20)
	camera.global_rotation = camera_target.global_rotation





func process_velocity() -> void:
	var input_dir: Vector2 = Input.get_vector("move_right", "move_left", "move_forward", "move_backward")
	var move_dir: Vector3 = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, rotation.y)
	velocity = move_dir * speed




func process_camera_target_look_rotation(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_target.rotate_x(-event.relative.y * 0.01)
		camera_target.rotation.x = clamp(camera_target.rotation.x, deg_to_rad(-89), deg_to_rad(89))




func process_look_rotation(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.01)






