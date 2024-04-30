extends "res://src/character.gd"

signal died

@export var speed = 300.0
@export var jump_velocity = -400.0
@onready var start_positon = self.global_position


func _character_physics_process(_delta: float) -> void:
	_handle_jump()
	_input_movement()


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


func _die() -> void:
	# TODO -> Play animation
	var hurt_area = $HurtArea
	
	global_position = start_positon
	died.emit()
	hurt_area.health = hurt_area.health_max
