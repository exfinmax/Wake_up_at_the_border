# 生命值组件，负责管理角色血量、死亡判定等
extends Node2D
class_name Health

# 基础属性设置
@export_category("Health Settings")
@export var max_hp: float = 100.0  # 最大生命值
@export var hp_recover_speed: float = 0.0  # 生命值恢复速度（每秒）
@export var can_recover_hp: bool = false  # 是否允许生命值自动恢复

# UI显示设置
@export_category("UI Settings")
@export var can_show: bool = false  # 是否显示血条
@export var texture_under: Texture2D  # 血条背景纹理
@export var texture_progress: Texture2D  # 血条前景纹理

# 节点引用
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

# 当前生命值
var current_hp: float

# 信号定义
signal health_changed(new_hp: float)  # 生命值变化信号
signal health_depleted  # 生命值耗尽信号

# 初始化
func _ready() -> void:
	_setup_health_bar()
	_initialize_health()

# 生命值操作函数
func change_hp(amount: float) -> void:
	var old_hp = current_hp
	current_hp = clampf(current_hp + amount, 0, max_hp)
	_update_health_bar()
	
	# 发送信号
	health_changed.emit(current_hp)
	if old_hp > 0 and current_hp <= 0:
		health_depleted.emit()

# 状态检查函数
func is_hp_zero() -> bool:
	return current_hp <= 0

func get_current_hp() -> float:
	return current_hp

func get_hp_percentage() -> float:
	return current_hp / max_hp * 100.0

# 物理帧更新（处理生命值恢复）
func _physics_process(delta: float) -> void:
	if can_recover_hp and current_hp < max_hp:
		change_hp(hp_recover_speed * delta)

# 私有辅助函数
func _setup_health_bar() -> void:
	if texture_progress_bar:
		if texture_progress:
			texture_progress_bar.texture_progress = texture_progress
		if texture_under:
			texture_progress_bar.texture_under = texture_under
		texture_progress_bar.visible = can_show

func _initialize_health() -> void:
	if texture_progress_bar:
		texture_progress_bar.max_value = max_hp
		texture_progress_bar.value = max_hp
	current_hp = max_hp

func _update_health_bar() -> void:
	if texture_progress_bar:
		texture_progress_bar.value = current_hp
