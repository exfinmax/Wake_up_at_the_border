# 受伤状态
class_name PlayerStateHurt
extends PlayerState

const KNOCKBACK_VELOCITY :=   200  # 击退速度

var direction: Vector2i

func _enter_tree() -> void:
	player.can_recover_energy = false
	_apply_knockback()
	_play_hurt_animation()

func _process(_delta: float) -> void:
	await animation.animation_finished
	_handle_state_transition()

func _exit_tree() -> void:
	player.can_recover_energy = true

# 应用击退效果
func _apply_knockback() -> void:
	direction = sign(player.global_position - player_data.target.global_position)
	player.velocity = Vector2(KNOCKBACK_VELOCITY * direction.x, -100)


# 禁用能量恢复


# 播放受伤动画
func _play_hurt_animation() -> void:
	if player.is_defend && player.heading == -direction.x:
		animation.play("defend_t")
		player_data.target.get_hurt(min(player_data.num / 2, 20),player)
	elif health_component.is_hp_zero():
		animation.play("death")
		player.collision_layer = 0
	else:
		animation.play("hurt")

# 处理状态转换
func _handle_state_transition() -> void:
	player.velocity = Vector2.ZERO
	if health_component.is_hp_zero():
		_handle_death()
		return
	elif player.is_defend:
		player.is_defend = false
		player.current_energy -= 1
	transfrom_state(Player.State.MOVE)

# 处理死亡状态
func _handle_death() -> void:
	GameEvents.player_death.emit()
	player.collision_layer = 0

func set_heading() -> void:
	if player.velocity.x > 0:
		player.heading = 1
	elif player.velocity.x < 0:
		player.heading = -1
		
