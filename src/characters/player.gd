extends CharacterBody2D

signal died

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var fall_limit = 400.0
@onready var start_positon = self.global_position

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	_add_gravity(delta)
	_handle_jump()
	_input_movement()
	_handle_fall_limit()


func _add_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity


func _input_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()


func _handle_fall_limit() -> void:
	if global_position.y > fall_limit:
		die()


func die() -> void:
	# TODO -> Play animation
	global_position = start_positon
	died.emit()
	$HurtArea.health = $HurtArea.health_max
