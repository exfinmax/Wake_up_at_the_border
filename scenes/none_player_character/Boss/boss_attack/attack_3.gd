extends Area2D

@export var speed: float = 1000
var velocity: Vector2 = Vector2.ZERO
var target_position:Vector2
var is_ready:bool = false
@onready var attack: Attack = $Attack

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = randf_range(1,3)
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(on_timeout)


func _physics_process(delta: float) -> void:
	if is_ready:
		global_position += velocity * speed * delta


func set_velocity(_position:Vector2) -> void:
	target_position = _position
	velocity = (target_position - global_position).normalized()
	if velocity.x > 0:
		scale.x = 1
	else:
		scale.x = -1
	


func on_timeout() -> void:
	is_ready = true
	velocity = ((Global.player.global_position - Vector2(0, 50)) - global_position).normalized()
	if velocity.x > 0:
		scale.x = 1
	else:
		scale.x = -1
	look_at(target_position)
	

func _on_body_entered(_body: Node2D) -> void:
	attack.check_attack()
	queue_free()
