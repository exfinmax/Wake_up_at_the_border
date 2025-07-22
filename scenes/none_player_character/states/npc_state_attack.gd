# NPC攻击状态脚本，负责NPC攻击行为




class_name NpcStateAttack
extends NpcState

# 攻击目标节点
var target : Node2D
# 攻击动画索引
var index : int = 1

# 进入树形结构时调用
func _enter_tree() -> void:
	# 获取攻击目标
	target = npc_data.target
	
	

# 物理过程更新
func _physics_process(delta: float) -> void:
	# 如果无法进行有效攻击，则强制移动到目标位置
	if !npc.attack.can_useful_attack:
		froce_target(delta)
		return
	attack_target()
	await animation.animation_finished

# 强制移动到目标位置
func froce_target(delta: float) -> void:
	# 计算移动方向
	var direction = npc.position.direction_to(target.position)
	# 如果与目标距离大于5，则加速移动
	if npc.position.distance_to(target.position) > 5:
		# 如果目标在右侧，则向右加速
		if direction.x > 0:
			npc.velocity.x = clampf(npc.velocity.x + npc.run_speed * delta, 0, npc.run_speed)
		# 如果目标在左侧，则向左加速
		elif direction.x < 0:
			npc.velocity.x = clampf(npc.velocity.x + -npc.run_speed * delta, -npc.run_speed, 0)
	# 如果与目标距离小于等于5，则减速
	else:
		npc.velocity.x = move_toward(npc.velocity.x, 0, delta)

# 攻击目标
func attack_target() -> void:
	# 如果可以进行有效攻击
	if npc.attack.can_useful_attack:
		# 随机选择一个攻击动画索引
		index = randi_range(1, npc.attack.max_atk_index)
		# 播放攻击动画
		animation.play("attack_%s" % [str(index)])
		# 目标受到攻击
		target.get_hurt(npc.attack.get_attack_number())
		
		

	
