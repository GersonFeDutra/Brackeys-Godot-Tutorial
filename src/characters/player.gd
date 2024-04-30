extends "res://src/character.gd"

signal died

const KNOCKBACK_FORCE: float = 32.0
const DEATH_DELAY_DURATION: float = 1.5

@export var speed = 300.0
@export var jump_velocity = -400.0
@onready var start_positon = self.global_position
var _input_movement_enabled: bool = true


func _character_physics_process(_delta: float) -> void:
	_handle_jump()
	if _input_movement_enabled:
		_input_movement()
	move_and_slide()


func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity


func _input_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


func _die() -> void:
	# TODO -> Play animation
	var hurt_area = $HurtArea
	
	_set_fall_through(true)
	_knockback_apply(KNOCKBACK_FORCE)
	
	await _slowmo(.5, DEATH_DELAY_DURATION)
	global_position = start_positon
	_set_fall_through(false)
	
	died.emit()
	hurt_area.health = hurt_area.health_max


func _set_fall_through(enable: bool) -> void:
	$CollisionShape2D.set_deferred("disabled", enable)
	_input_movement_enabled = not enable

func _knockback_apply(force: float) -> void:
	velocity.x = sin(velocity.x * PI / 2.) * -force


func _slowmo(time_scale: float, duration: float) -> void:
	var timer = get_tree().create_timer(duration)
	Engine.time_scale = time_scale
	await timer.timeout
	Engine.time_scale = 1.0
