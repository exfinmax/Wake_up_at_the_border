# 防御状态：处理NPC的防御行为
class_name NpcStateDefend
extends NpcState

const DEFEND_DURATION := 1.0  # 最短防御时间
var defend_timer: float = 0.0
var is_defending: bool = false

func _enter_tree() -> void:
	animation.play("defend")
	is_defending = true
	npc.set_collision_layer_value(3, true)  # 启用防御碰撞层

func _handle_state_behavior(delta: float) -> void:
	defend_timer += delta
	
	# 应用减速
	apply_friction(delta)
	
	match npc.type:
		BaseNpc.Type.Enemy:
			_handle_enemy_defend()
		BaseNpc.Type.Npc:
			_handle_npc_defend()

# 处理敌人的防御行为
func _handle_enemy_defend() -> void:
	# 在防御时面向目标
	if npc.target:
		var direction = get_direction_to_target()
		npc.body.scale.x = npc.current_scale * sign(direction.x)
		
		# 检查是否应该结束防御
		if defend_timer >= DEFEND_DURATION:
			# 根据与目标的距离和血量决定是否继续防御
			var distance = get_distance_to_target()
			var health_percent = health_component.get_hp_percentage() if health_component else 100
			
			# 如果血量低且距离近，增加防御概率
			var defense_chance = 0.3  # 基础概率30%
			if health_percent < 50:
				defense_chance += 0.2  # 低血量时增加20%概率
			if distance < npc.attack_range * 1.5:
				defense_chance += 0.2  # 距离近时增加20%概率
				
			if randf() > defense_chance:
				_end_defend()

# 处理NPC的防御行为
func _handle_npc_defend() -> void:
	# NPC只在受到攻击时短暂防御
	if defend_timer >= DEFEND_DURATION:
		_end_defend()

func _end_defend() -> void:
	is_defending = false
	npc.set_collision_layer_value(3, false)  # 禁用防御碰撞层
	transfrom_state(BaseNpc.State.IDLE)

func _exit_tree() -> void:
	is_defending = false
	npc.set_collision_layer_value(3, false)  # 确保禁用防御碰撞层
