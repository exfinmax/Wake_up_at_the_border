# NPC受伤状态脚本，负责NPC受伤时的行为




class_name NpcStateHurt
extends NpcState

# 定义受伤时的击退速度
# 受伤时NPC会被击退，这个变量决定了击退的速度和方向
const KNOCKBACK_VELOCITY :Vector2 = Vector2.RIGHT 

# 进入受伤状态时调用
# 在NPC受伤时，会显示血条，并根据受伤程度播放动画
func _enter_tree() -> void:
	# 显示血条
	npc.health.show()
	# 受伤时NPC会被击退，击退方向与当前移动方向相反
	npc.velocity = KNOCKBACK_VELOCITY * -npc.velocity.x 
	# 如果NPC血量归零，则播放死亡动画
	if npc.health.is_hp_zero():
		animation.play("death")
	# 如果NPC血量未归零，则播放受伤动画
	else:
		animation.play("hurt")

# 受伤状态的物理更新
# 在受伤状态下，NPC会持续受到物理更新，直到动画播放完毕
func _physics_process(_delta: float) -> void:
	# 等待受伤动画播放完毕
	await animation.animation_finished
	# 受伤动画播放完毕后，NPC停止移动
	npc.velocity = Vector2.ZERO
	# 受伤动画播放完毕后，NPC转向
	npc.heading = -npc.heading
	# 受伤动画播放完毕后，隐藏血条
	npc.health.hide()
	# 如果NPC血量归零，则销毁NPC
	if npc.health.is_hp_zero():
		npc.queue_free()
	# 如果NPC血量未归零，则切换到移动状态
	else:
		transfrom_state(BaseNpc.State.MOVE)
