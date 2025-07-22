# 待机状态：NPC的默认状态，处理基本的待机行为
class_name NpcStateIdle
extends NpcState

var idle_time: float = 0.0
const MIN_IDLE_TIME := 1.0
const MAX_IDLE_TIME := 3.0
var next_action_time: float

var target: Node2D

func _enter_tree() -> void:
	animation.play("idle")
	next_action_time = randf_range(MIN_IDLE_TIME, MAX_IDLE_TIME)


func _physics_process(delta: float) -> void:
	_handle_state_behavior(delta)

func _handle_state_behavior(delta: float) -> void:
	target = attack_component.current_target
	idle_time += delta
	
	# 应用摩擦力使NPC完全停止
	apply_friction(delta)
	
	match npc.type:
		BaseNpc.Type.Enemy:
			_handle_enemy_idle()
		#BaseNpc.Type.Npc:
			#_handle_npc_idle()

func _handle_enemy_idle() -> void:
	# 如果发现目标，根据距离决定转换到追击或攻击状态
	if target:
		if can_attack_target():
			transfrom_state(BaseNpc.State.ATTACK)
		elif should_chase_target():
			transfrom_state(BaseNpc.State.MOVE)
	# 待机时间结束后，转换到移动状态进行巡逻
	elif idle_time >= next_action_time:
		transfrom_state(BaseNpc.State.MOVE)

func _handle_npc_idle() -> void:
	# NPC的待机行为更简单，主要是等待玩家互动
	if idle_time >= next_action_time:
		# 随机选择新的待机动画或小动作
		var animations = ["idle", "idle_2", "look_around"]
		var next_anim = animations[randi() % animations.size()]
		if animation.has_animation(next_anim):
			animation.play(next_anim)
		# 重置待机时间
		idle_time = 0.0
		next_action_time = randf_range(MIN_IDLE_TIME, MAX_IDLE_TIME)
