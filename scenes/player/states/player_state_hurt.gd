# 受伤状态
class_name PlayerStateHurt
extends PlayerState

const KNOCKBACK_VELOCITY := Vector2.LEFT * 300  # 击退速度

var direction: Vector2

func _enter_tree() -> void:
	_apply_knockback()
	_disable_energy_recovery()
	_play_hurt_animation()

func _physics_process(_delta: float) -> void:
	await animation.animation_finished
	_handle_state_transition()

func _exit_tree() -> void:
	player.can_recover_energy = true

# 应用击退效果
func _apply_knockback() -> void:
	direction = sign(player.global_position - player.target.global_position)
	player.velocity = KNOCKBACK_VELOCITY * direction.x

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
