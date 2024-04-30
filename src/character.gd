extends CharacterBody2D

@export var fall_limit = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_character_physics_process(delta)
	_handle_fall_limit()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func _handle_fall_limit() -> void:
	if global_position.y > fall_limit:
		_die()


# @Virtual
## Called during physics process step, used to specify character behaviours.
func _character_physics_process(_delta: float) -> void:
	pass


# @Virtual
func _die() -> void:
	pass
