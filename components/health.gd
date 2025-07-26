# 生命值组件，负责管理角色血量、死亡判定等
extends Node2D
class_name Health

# 基础属性设置
@export_category("Health Settings")
@export var max_hp: float = 100.0  # 最大生命值
@export var hp_recover_speed: float = 0.0  # 生命值恢复速度（每秒）
@export var can_recover_hp: bool = false  # 是否允许生命值自动恢复
@export var can_show: bool = true



@onready var parent:Node2D = $".."
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar




# 当前生命值
var current_hp: float

# 信号定义

signal health_depleted(body: BaseNpc)  # 生命值耗尽信号

func _ready() -> void:
	texture_progress_bar.visible = can_show
	texture_progress_bar.max_value = max_hp
	texture_progress_bar.value = max_hp
	current_hp = max_hp


# 生命值操作函数
func change_hp(amount: float) -> void:
	var old_hp = current_hp
	current_hp = min(current_hp + amount, max_hp)

	
	# 发送信号

	if old_hp > 0 and current_hp <= 0:
		health_depleted.emit(parent)

# 状态检查函数
func is_hp_zero() -> bool:
	return current_hp <= 0

func get_current_hp() -> float:
	return current_hp

func get_hp_percentage() -> float:
	return current_hp / max_hp * 100.0

# 物理帧更新（处理生命值恢复）
func _process(delta: float) -> void:
	texture_progress_bar.value = current_hp
	if can_recover_hp and current_hp < max_hp:
		change_hp(hp_recover_speed * delta)
