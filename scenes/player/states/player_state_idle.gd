class_name PlayerStateIdle
extends PlayerState

const COLD_TIME := 1000

var time_start_idle

func _enter_tree() -> void:
	player.linear_velocity = Vector2.ZERO
	time_start_idle = Time.get_ticks_msec()
	animation.play("idle")

func _physics_process(delta: float) -> void:
	if Time.get_ticks_msec() - time_start_idle > COLD_TIME:
		transfrom_state(Player.State.MOVE)
