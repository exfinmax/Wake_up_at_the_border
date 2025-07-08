class_name PlayerStateMove
extends PlayerState


var is_npc = false

func _enter_tree() -> void:
	detect_area.body_entered.connect(on_detect_area.bind())
	animation.play("idle")

func _physics_process(delta: float) -> void:
	unhand_input(delta)
	change_ani()
	if player.linear_velocity.y != 0:
		transfrom_state(Player.State.AIR)
	
func unhand_input(delta:float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		player.linear_velocity.y = -player.jump_speed
		transfrom_state(Player.State.AIR)
	elif Input.is_action_just_pressed("interact"):
		if is_npc:
			transfrom_state(Player.State.INTERACT)
		transfrom_state(Player.State.ATTACK)
	elif Input.is_action_just_pressed("ui_down"):
		transfrom_state(Player.State.DEFEND)
	elif Input.is_action_pressed("ui_left"):
		player.linear_velocity.x = clampf(player.linear_velocity.x + -player.walk_speed * delta * 10, -player.run_speed, 0)
	elif Input.is_action_pressed("ui_right"):
		player.linear_velocity.x = clampf(player.linear_velocity.x + player.walk_speed * delta * 10, 0, player.run_speed)

func change_ani() -> void:
	if absf(player.linear_velocity.x) > player.walk_speed:
		animation.play("run")
	elif player.linear_velocity == Vector2.ZERO:
		animation.play("idle")
	elif absf(player.linear_velocity.x) <= player.walk_speed:
		animation.play("walk")


func on_detect_area(body: Node2D) -> void:
	if body.is_in_group("npc"):
		is_npc = true
