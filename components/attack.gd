# 攻击组件，负责处理攻击判定和伤害逻辑
# 适用于玩家和NPC的近战攻击
extends Node2D
class_name Attack
# 攻击力，可在编辑器中设置
@export var atk: float = 10.0
# 最大连击数（可选）
@export var max_atk_index: int = 3
@export var only_once:bool
@export var check_between: float
@export var increase_knock: float = 1.0


# 攻击判定区域（需在场景中绑定Area2D）
@onready var attack_area: Area2D = $AttackArea
@onready var sourcer: Node2D = $"../.."
@onready var collision_shape_2d: CollisionShape2D = $AttackArea/CollisionShape2D

var time_since_check:= Time.get_ticks_msec()
# 攻击检测信号
var is_useful_attack:bool = false

func _ready() -> void:
	set_process(false)
	process_check()


# 获取当前攻击力
func get_attack_number() -> float:
	print(atk)
	return atk

# 触发攻击检测（如在攻击动画关键帧调用）
func check_attack(number: int = 1):
	for body in attack_area.get_overlapping_bodies():
		if body.has_method("get_hurt"):
			body.knock_back *= increase_knock
			body.get_hurt(get_attack_number(), sourcer, number)
			body.knock_back /= increase_knock
			is_useful_attack = true
	if only_once:
		queue_free()
	if attack_area.get_overlapping_bodies().is_empty():
		is_useful_attack = false

func _process(_delta: float) -> void:
	process_check()

func process_check() -> void:
	if check_between != 0:
		set_process(true)
		if Time.get_ticks_msec() - time_since_check > check_between:
			time_since_check = Time.get_ticks_msec()
			check_attack()
	
