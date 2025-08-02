# NPC攻击状态脚本，负责NPC攻击行为




class_name NpcStateAttack
extends NpcState

# 攻击目标节点
var target : Node2D
# 攻击动画索引
var max_index : int 
var is_attack: bool = false



var attack_timer: float = 0.0  # 攻击计时器
var can_attack: bool = true  # 是否可以攻击
var attack_combo: int = 1  # 连击计数


# 进入状态时的初始化
func _enter_tree() -> void:
	# 获取攻击目标并初始化状态
	target = npc_data.target
	max_index = attack_conpoment.max_atk_index

		



# 物理过程更新
func _process(delta: float) -> void:
	if not target:
		_switch_to_move()
		return
		
	attack_timer -= delta
	
	var distance:float = npc.global_position.distance_squared_to(target.global_position)
	
	if distance > (npc.attack_range * npc.attack_range)  && !is_attack:
		_chase_target(delta)
	else:
		_perform_attack()

# 追逐目标
func _chase_target(_delta: float) -> void:
	var direction = (target.global_position - npc.global_position).normalized()
	npc.velocity.x = direction.x * npc.run_speed
	
	if abs(npc.velocity.x) > 0:
		animation.play("move")
	# 如果距离过远，切换到移动状态
	if npc.global_position.distance_to(target.global_position) > npc.chase_range:
		_switch_to_move()

	
# 执行攻击
func _perform_attack() -> void:
	npc.velocity.x = 0
	
	if attack_timer <= 0 and can_attack:
		# 开始攻击动画
		is_attack = true
		animation.play("attack_" + str(randi_range(1, max_index)))
		attack_timer = npc.attack_colddown
		can_attack = false
		
		
		# 等待动画完成
		await animation.animation_finished
		
		# 处理连击
		attack_combo = (attack_combo % 3) + 1
		is_attack = false
		can_attack = true
		# 随机决定是否后退拉开距离
		if randf() < 0.3:
			_perform_backstep()

# 后退动作
func _perform_backstep() -> void:
	var direction = (npc.global_position - target.global_position).normalized()
	npc.velocity = direction * npc.run_speed * 1.5
	animation.play("jump")
	await animation.animation_finished
	npc.velocity.x = 0

# 切换到移动状态
func _switch_to_move() -> void:
	transfrom_state(BaseEnemy.State.MOVE)
