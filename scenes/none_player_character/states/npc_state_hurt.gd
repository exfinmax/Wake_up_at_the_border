# NPC受伤状态脚本，负责NPC受伤时的行为




class_name NpcStateHurt
extends NpcState

# 定义受伤时的击退速度
# 受伤时NPC会被击退，这个变量决定了击退的速度和方向

var direction: Vector2i
# 进入受伤状态时调用
# 在NPC受伤时，会显示血条，并根据受伤程度播放动画
func _enter_tree() -> void:
	# 如果NPC血量归零，则播放死亡动画
	
	
	direction = sign(npc.global_position - npc_data.target.global_position)
	npc.velocity = Vector2(npc.knock_back * direction.x, -100)
	npc.body.scale.x = npc.current_scale * -direction.x
	if npc.health.is_hp_zero():
		animation.play("death")
	# 如果NPC血量未归零，则播放受伤动画
	else:
		animation.play("hurt")

# 受伤状态的物理更新
# 在受伤状态下，NPC会持续受到物理更新，直到动画播放完毕
func _process(delta: float) -> void:
	npc.velocity.x = lerpf(npc.velocity.x, 0, delta * 2)
	# 等待受伤动画播放完毕
	await animation.animation_finished
	# 受伤动画播放完毕后，NPC停止移动
	npc.velocity = Vector2.ZERO
	# 受伤动画播放完毕后，隐藏血条
	npc.heading = -direction.x
	npc.body.scale.x = npc.current_scale * -direction.x
	
	# 如果NPC血量归零，则销毁NPC
	if npc.health.is_hp_zero():
		GameEvents.enemy_death.emit(npc)
	# 如果NPC血量未归零，则切换到移动状态
	else:
		if npc.is_fly:
			transfrom_state(BaseEnemy.State.AIR_MOVE, npc_data)
		else:
			transfrom_state(BaseEnemy.State.ATTACK, npc_data)
