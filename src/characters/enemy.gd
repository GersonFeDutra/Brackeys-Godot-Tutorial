extends "res://src/character.gd"

@export_range(1., 999.) var speed: float = 4.0
var _heading_direction := Vector2.RIGHT.x

@onready var raycast := $RayCast2D
@onready var sprite := $AnimatedSprite2D


func _character_physics_process(delta: float) -> void:
	
	if raycast.is_colliding():
		_flip_direction()
	
	velocity.x += delta * speed * _heading_direction
	move_and_slide()


func _flip_direction() -> void:
	_heading_direction *= -1.
	raycast.target_position.x *= -1.
	sprite.flip_h = not sprite.flip_h
