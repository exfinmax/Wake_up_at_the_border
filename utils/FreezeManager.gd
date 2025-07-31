extends Node


func frame_freeze(time_scale:float, duration: float) -> void:
	Engine.time_scale = 1
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
