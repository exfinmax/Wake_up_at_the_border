# 空中状态
class_name PlayerStateAir
extends PlayerState

var is_fall:bool = false

func _enter_tree() -> void:
	animation.play("jump")

func _physics_process(_delta: float) -> void:
	# 下落时切换动画
	if player.velocity.y > 0 && !is_fall:
		animation.play("fall")
		is_fall = true
	# 落地切回移动
	elif player.velocity.y == 0:
		transfrom_state(Player.State.MOVE)
