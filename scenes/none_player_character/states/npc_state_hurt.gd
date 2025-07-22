# NPC受伤状态脚本，负责NPC受伤时的行为




# NPC受伤状态：处理受伤、击退和死亡逻辑
class_name NpcStateHurt
extends NpcState

const KNOCKBACK_FORCE := 300.0
const HURT_DURATION := 0.2
const INVINCIBLE_DURATION := 1.0

var hurt_timer: float = 0.0
var knockback_direction: Vector2
var is_dying: bool = false
var player: Node2D

func _enter_tree() -> void:
	# 获取攻击者信息
	player = npc_data.target
	if player:
		# 计算攻击方向（直接使用位置差）
		var attack_direction :float= sign(player.global_position.x - npc.global_position.x)
		
		# 确保有效的朝向（如果在同一位置，保持当前朝向）
		if attack_direction != 0:
			npc.heading = attack_direction
			npc._update_visual_direction()
			
		# 计算击退速度（向后移动）
		npc.velocity = Vector2(KNOCKBACK_FORCE * -npc.heading, -100.0)
	
	# 检查生命值并播放相应动画
	if health_component:
		health_component.visible = true
		is_dying = health_component.is_hp_zero()
		
		if is_dying:
			animation.play("death")
			# 禁用碰撞
			npc.set_collision_layer_value(4, false)
			
		else:
			animation.play("hurt")
			# 开始无敌帧闪烁
			_start_invincibility()

func _physics_process(delta: float) -> void:
	_handle_state_behavior(delta)


func _handle_state_behavior(delta: float) -> void:
	hurt_timer += delta
	
	# 应用摩擦力减缓击退
	apply_friction(delta)
	
	if is_dying:
		_handle_death()
	else:
		_handle_recovery()

# 处理死亡状态
func _handle_death() -> void:
	if not animation.is_playing():
		# 等待一小段时间后销毁
		await get_tree().create_timer(0.5).timeout
		npc.queue_free()

# 处理恢复状态
func _handle_recovery() -> void:
	if hurt_timer >= HURT_DURATION:
		npc.velocity = Vector2.ZERO
		health_component.visible = false
		transfrom_state(BaseNpc.State.MOVE)

# 开始无敌帧效果
func _start_invincibility() -> void:
	var blink_timer := Timer.new()
	add_child(blink_timer)
	blink_timer.wait_time = 0.1
	blink_timer.timeout.connect(_on_blink_timeout)
	blink_timer.start()
	
	# 设置定时器在无敌时间后停止
	await get_tree().create_timer(INVINCIBLE_DURATION).timeout
	blink_timer.stop()
	blink_timer.queue_free()
	npc.modulate.a = 1.0

# 处理闪烁效果
func _on_blink_timeout() -> void:
	npc.modulate.a = 1.0 if npc.modulate.a < 1.0 else 0.5



# 状态退出时的清理
func _exit_tree() -> void:
	if not is_dying:
		npc.modulate.a = 1.0
		npc.set_collision_layer_value(4, true)
		npc.set_collision_mask_value(1, true)
