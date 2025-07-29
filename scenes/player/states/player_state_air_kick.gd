class_name PlayerStateAirKick
extends PlayerState

var current_atk: float
var total_delta:float

func _enter_tree() -> void:
	player.can_be_hurt = false
	player.current_energy -= 6
	player.can_recover_energy = false
	player.velocity.y += -100
	animation.play("pre_fly_kick")
	animation.animation_finished.connect(on_animation_finished.bind())
	current_atk = attack_component.atk
	attack_component.attack_area.body_entered.connect(on_body_entered.bind())



func _ready() -> void:
	await get_tree().create_timer(0.4).timeout
	if player.apply_gravity == false:
		player.velocity.x = player.run_speed * player.heading * 2.5
		player.velocity.y = player.run_speed * 2
	

func on_animation_finished(_name: StringName) -> void:
	player.apply_gravity = false
	animation.play("fly_kick")
	

func on_body_entered(_body: Node2D) -> void:
	player.camera_2d.shake()
	attack_component.atk = lerpf(current_atk+20, current_atk+150, total_delta)
	attack_component.check_attack()

func _process(delta: float) -> void:
	total_delta += delta
	player.can_be_hurt = false
	if player.is_on_floor():
		player.camera_2d.shake()
		player.velocity = Vector2.ZERO
		player.apply_gravity = true
		transfrom_state(Player.State.MOVE)
		



func _exit_tree() -> void:
	player.can_recover_energy = true
	player.apply_gravity = true
	player.can_be_hurt = true
	attack_component.atk = current_atk

	
