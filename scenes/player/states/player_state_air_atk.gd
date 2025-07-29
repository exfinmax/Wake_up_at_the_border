class_name PlayerStateAirAtk
extends PlayerState

var current_atk: float
var total_delta:float

func _enter_tree() -> void:
	player.current_energy -= 5
	player.can_recover_energy = false
	player.velocity.y -= 100
	animation.play("pre_air_atk")
	animation.animation_finished.connect(on_animation_finished.bind())
	current_atk = attack_component.atk
	attack_component.attack_area.body_entered.connect(on_body_entered.bind())
	player.can_be_hurt = false

func on_animation_finished(_name: StringName) -> void:
	animation.play("in_air_atk")

func on_body_entered(_body: Node2D) -> void:
	player.camera_2d.shake()
	attack_component.atk = lerpf(current_atk, current_atk+50, total_delta)


func _process(delta: float) -> void:
	player.can_be_hurt = false
	total_delta += delta
	if player.is_on_floor():
		set_process(false)
		player.camera_2d.shake()
		player.velocity = Vector2.ZERO
		animation.play("air_atk_land")
		await animation.animation_finished
		transfrom_state(Player.State.MOVE)

func _exit_tree() -> void:
	player.can_recover_energy = true
	attack_component.atk = current_atk
	player.can_be_hurt = true
