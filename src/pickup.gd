extends Area2D

const VALUE := 1
const Player := preload("res://src/characters/player.gd")

func _on_body_entered(body) -> void:
	var player = body as Player
	assert(player, "pickup unknown collider")
	
	player.pickup_coin(VALUE)
	queue_free()
