class_name PlayerStateHurt
extends PlayerState

const KNOCKBACK_VELOCITY :Vector2 = Vector2.LEFT * 300

func _enter_tree() -> void:
	player.velocity = KNOCKBACK_VELOCITY * player.heading
	player.can_recover_energy = false
	if player.is_defend:
		animation.play("defend_t")
	elif player.health.is_hp_zero():
		animation.play("death")
		
	else:
		animation.play("hurt")
		

func _physics_process(_delta: float) -> void:
	await animation.animation_finished
	player.health.hide()
	if player.health.is_hp_zero():
		GameEvents.player_death.emit()
		player.collision_layer = 0
	elif player.is_defend:
		player.is_defend = false
		transfrom_state(Player.State.DEFEND)
	else:
		transfrom_state(Player.State.MOVE)

func _exit_tree() -> void:
	player.can_recover_energy = true
