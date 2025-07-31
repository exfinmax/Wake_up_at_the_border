# 防御状态
class_name PlayerStateDefend
extends PlayerState

func _enter_tree() -> void:
	player.velocity = Vector2.ZERO
	player.can_recover_energy = false
	animation.play("defend")
	player.is_defend = true
	
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		player.body.scale.x = -abs(player.body.scale.x)
		player.heading = -1
	elif Input.is_action_just_pressed("ui_right"):
		player.body.scale.x = abs(player.body.scale.x)
		player.heading = 1
	elif player.can_dash && Input.is_action_just_pressed("interact") && (Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left")) && player.current_energy > 2:
		transfrom_state(Player.State.DASH)
	
	elif Input.is_action_just_pressed("interact") && player.can_laser:
		transfrom_state(Player.State.LASER)
	
	
	if Input.is_action_just_released("ui_down"):
		transfrom_state(Player.State.MOVE)

func _exit_tree() -> void:
	player.can_recover_energy = true
	player.is_defend = false
