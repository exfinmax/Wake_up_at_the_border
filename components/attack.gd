# 攻击组件，负责处理攻击判定和伤害逻辑
# 适用于玩家和NPC的近战攻击
extends Node2D
class_name Attack
# 攻击力，可在编辑器中设置
@export var atk: float = 10.0
# 最大连击数（可选）
@export var max_atk_index: int = 3

# 攻击判定区域（需在场景中绑定Area2D）
@onready var area: Area2D = $Area2D if has_node("Area2D") else null

# 攻击检测信号
signal attack_hit(target)

# 是否可以进行有效攻击（如动画帧判定）
var can_useful_attack: bool = true

# 获取当前攻击力
func get_attack_number() -> float:
	return atk

# 触发攻击检测（如在攻击动画关键帧调用）
func check_attack():
	if area:
		for body in area.get_overlapping_bodies():
			if body.has_method("get_hurt"):
				body.get_hurt(get_attack_number())
				emit_signal("attack_hit", body)

# 可选：重置攻击状态
func reset_attack():
	can_useful_attack = true
