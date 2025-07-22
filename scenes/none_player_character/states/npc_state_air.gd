# NPC空中状态脚本，负责NPC在空中时的行为
class_name NpcStateAir
extends NpcState

const MAX_FALL_SPEED := 1000.0  # 最大下落速度
const AIR_CONTROL := 0.5       # 空中控制度（比地面移动慢）

func _enter_tree() -> void:
	# 根据垂直速度选择动画
	animation.play("jump" if npc.velocity.y < 0 else "fall")

func _handle_state_behavior(delta: float) -> void:
	# 应用重力
	npc.velocity.y = move_toward(npc.velocity.y, MAX_FALL_SPEED, BaseNpc.GRAVITY * delta)
	
	# 根据垂直速度更新动画
	if npc.velocity.y > 0 and animation.current_animation == "jump":
		animation.play("fall")
	
	match npc.type:
		BaseNpc.Type.Enemy:
			_handle_enemy_air_movement(delta)
		BaseNpc.Type.Npc:
			_handle_npc_air_movement(delta)
	
	# 检查着陆
	if npc.is_on_floor():
		_on_landed()

# 处理敌人空中移动
func _handle_enemy_air_movement(delta: float) -> void:
	if npc.target:
		var distance = get_distance_to_target()
		if distance < npc.chase_range:
			# 在空中仍然试图追踪目标，但控制度较低
			var direction = get_direction_to_target()
			apply_friction(delta)
	else:
		# 没有目标时，保持当前方向但减速
		apply_friction(delta)

# 处理NPC空中移动
func _handle_npc_air_movement(delta: float) -> void:
	# NPC在空中只进行最基本的移动
	apply_friction(delta * 2)

# 着陆处理
func _on_landed() -> void:
	npc.velocity.y = 0
	
	# 根据情况选择下一个状态
	if npc.type == BaseNpc.Type.Enemy and npc.target:
		if get_distance_to_target() <= npc.attack_range:
			transfrom_state(BaseNpc.State.ATTACK)
		else:
			transfrom_state(BaseNpc.State.MOVE)
	else:
		transfrom_state(BaseNpc.State.IDLE)
	
		
	
