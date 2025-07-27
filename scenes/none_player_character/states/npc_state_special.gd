# NPC特殊状态脚本，负责NPC特殊行为
class_name NpcStateSpecialGolem
extends NpcState

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
	max_index = 2

	



# 物理过程更新
func _process(delta: float) -> void:
	if !is_attack:
		attack_timer -= delta

	var distance = npc.global_position.distance_to(target.global_position)
	
	if distance > npc.attack_range && !is_attack:
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


# 执行攻击
func _perform_attack() -> void:
	npc.velocity.x = 0
	
	if attack_timer <= 0 and can_attack:
		# 开始攻击动画
		is_attack = true
		animation.play("attack_" + str(rand_index()))
		attack_timer = npc.attack_colddown
		can_attack = false
		
		
		# 等待动画完成
		await animation.animation_finished
		
		# 处理连击
		attack_combo = (attack_combo % 3) + 1
		is_attack = false
		can_attack = true

func rand_index() -> int:
	var number = randi_range(0,3)
	if number < 3:
		return 1
	else:
		return 2
