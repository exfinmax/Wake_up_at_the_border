extends Area2D

var pulse_time: float
var is_casting:bool = true

@onready var laser: RayCast2D = $".."


func _on_body_entered(body: Node2D) -> void:
	is_casting = false
	if body.has_method("get_hurt"):
		body.get_hurt(30, self, 5)
