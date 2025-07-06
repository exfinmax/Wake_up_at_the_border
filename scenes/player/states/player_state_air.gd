class_name PlayerStateAir
extends PlayerState

var is_fall:bool = false

func _enter_tree() -> void:
	animation.play("jump")

func _physics_process(delta: float) -> void:
	if player.linear_velocity.y > 0 && !is_fall:
		animation.play("fall")
		is_fall = true
	elif player.linear_velocity.y == 0:
		transfrom_state(Player.State.MOVE)
