class_name PlayerStateDefend
extends PlayerState

func _enter_tree() -> void:
	player.can_recover_energy = false
	animation.play("defend")
	defend_area.monitoring = true
	defend_area.area_entered.connect(on_defend_area.bind())

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("ui_down"):
		player.can_recover_energy = true
		transfrom_state(Player.State.MOVE)

func on_defend_area(area: Area2D) -> void:
	if player.current_energy > 2:
		player.is_defend = true
