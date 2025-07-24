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
	elif Input.is_action_just_pressed("ui_right"):
		player.body.scale.x = abs(player.body.scale.x)
	
	if Input.is_action_just_released("ui_down"):
		player.can_recover_energy = true
		player.is_defend = false
		transfrom_state(Player.State.MOVE)

# 检查能量，决定是否进入防御
