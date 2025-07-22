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

# 攻击检测信号
signal attack_hit(target)

# 是否可以进行有效攻击（如动画帧判定）
var can_useful_attack: bool = true
var current_target: Node2D = null

# 获取当前攻击力
func get_attack_number() -> float:
	return atk

# 触发攻击检测（如在攻击动画关键帧调用）
func check_attack():
	if current_target != null && current_target.has_method("get_hurt"):
		current_target.get_hurt(get_attack_number(), current_target)
		emit_signal("attack_hit", current_target)
		can_useful_attack = false

# 可选：重置攻击状态
func reset_attack():
	can_useful_attack = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	current_target = body


func _on_attack_area_body_exited(body: Node2D) -> void:
	current_target = null
