extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Engine.time_scale=0.5
		body.queue_free()
		timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale=1.0
	if ResourceLoader.exists("user://savegame.tres"):
		GameEvents.player_death.emit()
	else:
		get_parent().reload_current_stage()
	
