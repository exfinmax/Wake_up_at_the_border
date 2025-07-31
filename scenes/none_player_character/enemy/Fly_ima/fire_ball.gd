extends Area2D

@export var speed: float = 1000
var velocity: Vector2 = Vector2.ZERO
var target_position:Vector2
var all_delta: float

func _physics_process(delta: float) -> void:
	all_delta += delta
	global_position += velocity * speed * delta
	if all_delta > 3:
		queue_free()

func set_velocity(_position:Vector2) -> void:
	target_position = _position
	velocity = (target_position - global_position).normalized()
	

func _on_body_entered(body: Node2D) -> void:
	body.get_hurt(20, self, 2)
