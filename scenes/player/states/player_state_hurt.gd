# 受伤状态
class_name PlayerStateHurt
extends PlayerState



var direction: Vector2i

func _enter_tree() -> void:
	player.camera_2d.shake()
	player.is_defend = false
	player.can_recover_energy = false
	_apply_knockback()
	_play_hurt_animation()

func _process(_delta: float) -> void:
	set_process(false)
	await animation.animation_finished
	_handle_state_transition()

func _exit_tree() -> void:
	player.can_recover_energy = true

# 应用击退效果
func _apply_knockback() -> void:
	if player_data.target != null:
		direction = sign(player.global_position - player_data.target.global_position)
		player.velocity = Vector2(player.knock_back * direction.x, -100)


# 禁用能量恢复


# 播放受伤动画
func _play_hurt_animation() -> void:
	if health_component.is_hp_zero():
		animation.play("death")
		FreezeManager.frame_freeze(0, 0.1)
	else:
		animation.play("hurt")
		FreezeManager.frame_freeze(0.3, 0.15)
		

# 处理状态转换
func _handle_state_transition() -> void:
	player.velocity = Vector2.ZERO
	if health_component.is_hp_zero():
		
		player.collision_layer = 0
		_handle_death()
		return
	transfrom_state(Player.State.MOVE)

# 处理死亡状态
func _handle_death() -> void:
	await get_tree().create_timer(0.5).timeout
	if Global.current_stage != "stage_5":
		GameEvents.player_death.emit()


func set_heading() -> void:
	if player.velocity.x > 0:
		player.heading = 1
	elif player.velocity.x < 0:
		player.heading = -1
		
