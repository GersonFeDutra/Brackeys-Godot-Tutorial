@tool
extends Node2D


func _ready() -> void:
	if Engine.is_editor_hint():
		%Camera2D.limit_bottom = %Character.fall_limit
