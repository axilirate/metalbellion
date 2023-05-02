class_name TestEnemy extends CharacterBody3D



@export var collision_shape: CollisionShape3D
@export var health_bar: HealthBar

var attributes := Attributes.new()








func _process(delta: float) -> void:
	process_health()
	update_health_bar()





func process_health() -> void:
	if attributes.health <= 0:
		queue_free()




func update_health_bar() -> void:
	health_bar.progress_bar.max_value = attributes.max_health
	health_bar.progress_bar.value = attributes.health
