# NPC移动状态脚本，负责NPC在地面上的行为




class_name NpcStateMove
extends NpcState

# 随机改变方向的标志
var rand_change: bool = false

func _enter_tree() -> void:
	# 玩家进入检测区域时触发
	set_rand_change()
	player_detect_area.body_entered.connect(on_detect_player.bind())


	



func _physics_process(delta: float) -> void:
	# 检测并更新朝向
	ray_cast_detect()
	
	# 根据当前朝向更新移动
	var target_speed := npc.walk_speed * npc.heading
	npc.velocity.x = lerpf(npc.velocity.x, target_speed, npc.acceleration * delta)
	
	# 直接更新动画（因为朝向由基类处理）
	if abs(npc.velocity.x) > 0.1:
		animation.play("move")
	else:
		animation.play("idle")
	
	# 检查是否需要切换到空中状态
	if not npc.is_on_floor():
		transfrom_state(BaseNpc.State.AIR)
	
func ray_cast_detect() -> void:
	# 根据射线检测判断是否需要改变方向
	if floor_ray_cast and not floor_ray_cast.is_colliding():
		# 如果前方没有地面，立即改变方向
		npc.set_heading_value(-npc.heading)
		npc.velocity.x = 0  # 停止当前移动
		rand_change = false
	elif rand_change:
		# 随机改变方向
		npc.set_heading_value(-npc.heading)
		npc.velocity.x = 0  # 停止当前移动
		rand_change = false

func on_detect_player(player: Player) -> void:
	# 当检测到玩家时触发
	# 切换到攻击状态，并传递玩家数据
	transfrom_state(BaseNpc.State.ATTACK,NpcData.build().add_player(player))

func set_rand_change() -> void:
	# 设置随机改变方向的逻辑
	# 如果当前没有随机改变方向，则有概率进行随机改变
	if !rand_change:
		# 生成一个0到1之间的随机数
		var random_value = randf_range(0,1)
		# 如果随机数大于0.8，则设置为true，否则为false
		rand_change = true if random_value > 0.8 else false
		# 等待一段时间后再次尝试设置随机改变方向
		await get_tree().create_timer(3).timeout
		# 递归调用自身，实现循环
		set_rand_change()
		

func set_move_animation() -> void:
	# 如果NPC不能进行有效攻击，则根据其速度播放相应的动画
	if not attack_component.can_useful_attack:
		# 根据速度选择动画
		animation.play("move" if abs(npc.velocity.x) > 0.1 else "idle")
