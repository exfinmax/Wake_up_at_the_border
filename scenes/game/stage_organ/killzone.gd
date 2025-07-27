extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Engine.time_scale=0.5
		body.queue_free()
		timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale=1.0
	GameEvents.player_death.emit()
	
