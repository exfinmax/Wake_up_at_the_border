class_name PlayerStateLaser
extends PlayerState


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	player.is_defend = true
	player.is_laser = true
	player.velocity = Vector2(player.run_speed * -player.heading, 0)
	player.laser.visible = true
	player.laser.duration = 99
	player.can_recover_energy = false
	player.laser.target_position.x = player.heading
	player.laser.max_length = 9999
	player.laser.laser_width = 100
	animation.play("laser")
	animation.animation_finished.connect(on_ani_finished.bind())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.current_energy > 0 && Input.is_action_pressed("interact"):
		player.current_energy -= delta * 8
	else:
		player.laser.disappear()
		await get_tree().create_timer(0.15).timeout
		transfrom_state(Player.State.HURT)
		

func on_ani_finished(ani_name:StringName) -> void:
	if ani_name == "laser":
		player.velocity = Vector2.ZERO
		player.laser.set_is_casting(true)


func _exit_tree() -> void:
	player.laser.visible = false
	player.is_laser = false
	player.is_defend = false
	player.can_recover_energy = true
	
