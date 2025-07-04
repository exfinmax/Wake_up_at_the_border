class_name PlayerStateMove
extends PlayerState

var is_run:bool = false

func _enter_tree() -> void:
	animation.play("walk")

func _physics_process(delta: float) -> void:
	player.linear_velocity.x = clampf(player.linear_velocity.x + delta * player.run_speed * player.heading, -player.walk_speed, player.run_speed)
	if !floor_ray_cast.is_colliding():
		transfrom_state(Player.State.AIR)
	elif player.linear_velocity.x > player.walk_speed && !is_run:
		animation.play("run")
		is_run = true
	
