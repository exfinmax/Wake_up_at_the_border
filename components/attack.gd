# 攻击组件，负责处理攻击判定和伤害逻辑
# 适用于玩家和NPC的近战攻击
extends Node2D
class_name Attack
# 攻击力，可在编辑器中设置
@export var atk: float = 10.0
# 最大连击数（可选）
@export var max_atk_index: int = 3

# 攻击判定区域（需在场景中绑定Area2D）
@onready var attack_area: Area2D = $AttackArea
@onready var sourcer: Node2D = $"../.."


# 攻击检测信号
signal attack_hit(target)



# 获取当前攻击力
func get_attack_number() -> float:
	return atk

# 触发攻击检测（如在攻击动画关键帧调用）
func check_attack():
	for body in attack_area.get_overlapping_bodies():
		if body.has_method("get_hurt"):
			body.get_hurt(get_attack_number(), sourcer)
			emit_signal("attack_hit", body)
			
