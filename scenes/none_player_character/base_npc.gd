# NPC基类，负责NPC的基础属性和行为




class_name BaseNpc
extends CharacterBody2D

const GRAVITY :float = 980.0

# NPC类型和状态枚举
enum Type {Enemy, Npc, Boss}
enum State {
	MOVE,   # 移动状态
	AIR,    # 空中状态
	ATTACK, # 攻击状态
	HURT,   # 受伤状态
	DEFEND, # 防御状态
	IDLE,   # 待机状态
	SPECIAL # 特殊状态
}

# 移动相关属性
@export_category("Move")
@export var walk_speed: float = 100.0
@export var run_speed: float = 200.0
@export var jump_speed: float = 400.0
@export var friction: float = 10.0
@export var acceleration: float = 15.0

# NPC类型设置
@export_category("NPC Settings")
@export var type: Type
@export var attack_cooldown: float = 0.0  # 攻击冷却 
@export var attack_range: float = 50.0  # 攻击范围
@export var chase_range: float = 200.0  # 追击范围
@export var patrol_range: float = 100.0 # 巡逻范围

# 节点引用
@onready var body: Node2D = %Body
@onready var health_component: Health = %Health

var animation_player :AnimationPlayer = null

# 状态相关变量
var heading: int = 1
var state_factory := NpcStateFactory.new()
var current_state: NpcState
#var spawn_position: Vector2
var can_get_hurt: bool = true
var target: Node2D = null
# 信号
signal state_changed(new_state: State)


func _ready() -> void:
	#spawn_position = global_position
	switch_state(State.IDLE)

func _physics_process(delta: float) -> void:
	# 更新攻击冷却
	if attack_cooldown > 0:
		attack_cooldown -= delta
		
	_apply_friction(delta)
	_update_facing_direction()
	move_and_slide()
	
	

# 直接设置朝向值（1为右，-1为左）
func set_heading_value(new_heading: int) -> void:
	if new_heading != 0 and new_heading != heading:
		heading = new_heading
		_update_visual_direction()

# 根据移动方向更新朝向
func _update_facing_direction() -> void:
	if velocity.x != 0 and not current_state is NpcStateHurt:
		set_heading_value(sign(velocity.x))

# 根据方向向量设置朝向
func set_heading_from_direction(direction: Vector2) -> void:
	if direction.x != 0:
		set_heading_value(sign(direction.x))

# 获取到目标的方向向量
func get_direction_to(target_pos: Vector2) -> Vector2:
	return (target_pos - global_position).normalized()

# 面向目标（可以选择是否立即转向）
func face_target(target_pos: Vector2, immediate: bool = true) -> void:
	var dir := get_direction_to(target_pos)
	if immediate or sign(dir.x) == heading:
		set_heading_from_direction(dir)
		# 确保视觉更新
		_update_visual_direction()

# 更新视觉方向
func _update_visual_direction() -> void:
	if body:
		body.scale.x = 1.5 * heading

# 应用摩擦力
func _apply_friction(delta: float) -> void:
	if !is_on_floor():
		velocity.y = velocity.y + GRAVITY * delta




func get_hurt(current_atk:float, sourcer: Node2D) -> void:
	if can_get_hurt:
		health_component.change_hp(-current_atk)
		if type != Type.Boss:
			switch_state(State.HURT, NpcData.build().add_player(sourcer))
	
func switch_state(state:State, data:NpcData = NpcData.new()) -> void:
	pass
