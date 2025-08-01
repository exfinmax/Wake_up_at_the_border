# NPC移动状态脚本，负责NPC在地面上的行为
class_name NpcStateMove
extends NpcState

# 随机改变方向的标志
var rand_change: bool = false

func _enter_tree() -> void:
	# 玩家进入检测区域时触发
	player_detect_area.body_entered.connect(on_detect_player.bind())
	set_rand_change()

func _physics_process(delta: float) -> void:
	# 物理过程，负责更新NPC的位置和状态
	ray_cast_detect()
	set_move_animation(delta)
	
	# 如果NPC在垂直方向上有速度，则切换到空中状态
	if npc.velocity.y != 0:
		transfrom_state(BaseEnemy.State.AIR)
	
func ray_cast_detect() -> void:
	# 射线检测，用于判断NPC是否在地面上
	# 如果射线未碰撞到地面，或者需要随机改变方向
	
	if (not floor_ray_cast.is_colliding()) || rand_change || wall_ray_cast.is_colliding():
		# 停止NPC的水平速度
		npc.velocity.x = 0
		# 改变NPC的朝向
		
		npc.heading = -npc.heading
		# 重置随机改变方向的标志
		rand_change = false
		# 等待一段时间后再次尝试随机改变方向
		set_physics_process(false)
		npc.velocity = Vector2.ZERO
		animation.play("idle")
		await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
		set_physics_process(true)
		
		


func on_detect_player(player: Player) -> void:
	# 当检测到玩家时触发
	# 切换到攻击状态，并传递玩家数据
	transfrom_state(BaseEnemy.State.ATTACK,NpcData.build().add_player(player))

func set_rand_change() -> void:
	# 设置随机改变方向的逻辑
	# 如果当前没有随机改变方向，则有概率进行随机改变
	if !rand_change:
		# 生成一个0到1之间的随机数
		var random_value = randf_range(0,1)
		# 如果随机数大于0.8，则设置为true，否则为false
		rand_change = true if random_value > 0.9 else false
		# 等待一段时间后再次尝试设置随机改变方向
		if get_tree() != null:
			await get_tree().create_timer(5).timeout
		# 递归调用自身，实现循环
		set_rand_change()
		

func set_move_animation(delta:float) -> void:
	# 设置移动动画的逻辑
	# 根据NPC的朝向和速度更新其水平速度
	if npc.heading > 0:
		npc.velocity.x = clampf(npc.velocity.x + npc.walk_speed * delta * npc.heading, 0, npc.heading * npc.walk_speed)
		# 如果目标在左侧，则向左加速
	elif npc.heading < 0:
		npc.velocity.x = clampf(npc.velocity.x + npc.walk_speed * delta * npc.heading, npc.heading * npc.walk_speed, 0)
	# 如果NPC不能进行有效攻击，则根据其速度播放相应的动画
	# 如果NPC水平速度为0，则播放待机动画
	if abs(npc.velocity.x) < 3:
		animation.play("idle")
	# 如果NPC水平速度不为0，则播放移动动画
	elif npc.velocity.x != 0:
		animation.play("move")
