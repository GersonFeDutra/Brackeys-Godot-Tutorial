extends Area2D

const VALUE := 1
const Player := preload("res://src/characters/player.gd")

func _on_body_entered(body) -> void:
	var player = body as Player
	assert(player, "pickup unknown collider")
	
	var sfx = $SFX
	player.pickup_coin(VALUE)
	sfx.play()
	visible = false
	$CollisionShape2D.disabled
	await sfx.finished
	queue_free()
