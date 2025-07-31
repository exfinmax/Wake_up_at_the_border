extends Node2D

func _ready() -> void:
	self.set_instance_shader_parameter("outline_width", 0.5)

func _on_timer_timeout() -> void:
	queue_free()
