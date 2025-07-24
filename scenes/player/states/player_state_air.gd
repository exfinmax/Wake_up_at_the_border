# 空中状态
class_name PlayerStateAir
extends PlayerState

var is_fall:bool = false
var is_double_jump:bool = false

func _enter_tree() -> void:
	animation.play("jump")

func _process(_delta: float) -> void:
	# 下落时切换动画
	if player.velocity.y > 0 && !is_fall:
		animation.play("fall")
		is_fall = true
	if player.can_double_jump && !is_double_jump && Input.is_action_just_pressed("ui_up"):
		animation.play("double_jump")
		is_double_jump = true
		player.velocity.y = -player.jump_speed
	# 落地切回移动
	elif player.velocity.y == 0:
		transfrom_state(Player.State.MOVE)
