# 受伤状态
class_name PlayerStateHurt
extends PlayerState

const KNOCKBACK_VELOCITY := Vector2.LEFT * 300  # 击退速度

var enemy: Node2D


func _enter_tree() -> void:
	enemy = player_data.target
	health_component.show()
	_apply_knockback()
	_disable_energy_recovery()
	_play_hurt_animation()

func _physics_process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.friction * delta)
	

func _exit_tree() -> void:
	player.can_recover_energy = true

# 应用击退效果
func _apply_knockback() -> void:
	if enemy:
		# 计算到攻击者的方向
		var dir_to_attacker = player.get_direction_to(enemy.global_position)
		var attack_direction :float= sign(enemy.global_position.x - player.global_position.x)
		
		# 确保有效的朝向（如果在同一位置，保持当前朝向）
		if attack_direction != 0:
			player.heading = attack_direction
			player._update_visual_direction()
			
		# 设置击退速度（向后移动）
		player.velocity = Vector2(300.0 * -player.heading, -100.0)

# 禁用能量恢复
func _disable_energy_recovery() -> void:
	player.can_recover_energy = false

# 播放受伤动画
func _play_hurt_animation() -> void:
	if player.is_defend:
		animation.play("defend_t")
	elif health_component.is_hp_zero():
		animation.play("death")
	else:
		animation.play("hurt")
	await animation.animation_finished
	_handle_state_transition()
# 处理状态转换
func _handle_state_transition() -> void:
	if health_component:
		health_component.visible = false
		
		if health_component.is_hp_zero():
			_handle_death()
		elif player.is_defend:
			player.is_defend = false
		transfrom_state(Player.State.MOVE)

# 处理死亡状态
func _handle_death() -> void:
	GameEvents.player_death.emit()
	player.collision_layer = 0
