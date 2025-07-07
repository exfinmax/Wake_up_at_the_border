class_name PlayerStateHurt
extends PlayerState

var is_death := false

func _enter_tree() -> void:
	player.can_recover_energy = false
	if player.is_defend:
		animation.play("defend_t")
	elif player.hp > 0:
		animation.play("hurt")
	else:
		animation.play("death")
		is_death = true

func _physics_process(delta: float) -> void:
	await animation.animation_finished
	if is_death:
		GameEvents.player_death.emit()
	elif player.is_defend:
		player.is_defend = false
		transfrom_state(Player.State.DEFEND)
	else:
		transfrom_state(Player.State.MOVE)

func _exit_tree() -> void:
	player.can_recover_energy = true
