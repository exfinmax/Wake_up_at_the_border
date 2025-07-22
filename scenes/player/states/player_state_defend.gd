# 防御状态
class_name PlayerStateDefend
extends PlayerState

func _enter_tree() -> void:
	player.can_recover_energy = false
	animation.play("defend")
	defend_area.area_entered.connect(on_defend_area.bind())

func _physics_process(delta: float) -> void:
	player.velocity.x = lerpf(player.velocity.x, 0, player.friction * delta)
	if Input.is_action_just_released("ui_down"):
		player.can_recover_energy = true
		transfrom_state(Player.State.MOVE)

# 检查能量，决定是否进入防御
func on_defend_area(_area: Area2D) -> void:
	if player.current_energy > 2:
		player.is_defend = true
