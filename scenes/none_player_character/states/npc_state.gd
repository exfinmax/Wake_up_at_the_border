# NPC状态基类，所有NPC状态都继承自此类
class_name NpcState
extends Node

# 状态变更信号
signal state_change(state: BaseNpc.State, data: NpcData)

# 基础引用
var npc: BaseNpc                    # NPC实例引用
var animation: AnimationPlayer       # 动画播放器引用
var player_detect_area: Area2D      # 玩家检测区域      
var health_component: Health        # 生命值组件
var attack_component: Attack        # 攻击组件
var npc_data: NpcData              # NPC数据
var floor_ray_cast: RayCast2D

# 状态数据 
var can_transition: bool = true    # 是否可以转换状态

# 初始化状态
func setup(context_npc: BaseNpc, context_animation: AnimationPlayer, context_floor_detect: RayCast2D, context_data: NpcData,context_player_detect_area: Area2D = null) -> void:
	npc = context_npc
	animation = context_animation
	floor_ray_cast = context_floor_detect
	npc_data = context_data
	player_detect_area = context_player_detect_area
	
	# 获取组件引用
	attack_component = npc.get_node_or_null("%Attack")
	health_component = npc.get_node_or_null("%Health")

# 物理更新




# 状态转换
func transfrom_state(state: BaseNpc.State, data: NpcData = null) -> void:
	if can_transition:
		state_change.emit(state, data)

# 通用辅助方法

# 检查是否在地面
func is_on_ground() -> bool:
	return npc.is_on_floor()

# 获取到目标的距离
func get_distance_to_target() -> float:
	if npc.target:
		return npc.global_position.distance_to(npc.target.global_position)
	return INF

# 获取到目标的方向
func get_direction_to_target() -> Vector2:
	if npc.target:
		return (npc.target.global_position - npc.global_position).normalized()
	return Vector2.ZERO

# 检查是否可以攻击目标
func can_attack_target() -> bool:
	if not npc.target or not attack_component:
		return false
	var distance = get_distance_to_target()
	return distance <= npc.attack_range and npc.attack_cooldown <= 0

# 检查是否应该追击目标
func should_chase_target() -> bool:
	if not npc.target:
		return false
	var distance = get_distance_to_target()
	return distance <= npc.chase_range and distance > npc.attack_range


# 应用摩擦力
func apply_friction(delta: float) -> void:
	if abs(npc.velocity.x) > 0:
		npc.velocity.x = move_toward(npc.velocity.x, 0, npc.friction * delta)
