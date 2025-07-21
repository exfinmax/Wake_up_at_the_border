class_name PlayerStateAttack
extends PlayerState

var DURATION := 600

var time_start_attack
var index := 1
var is_animation_finished := false

func _enter_tree() -> void:
	detect_area.monitoring = true
	detect_area.body_entered.connect(on_detect_area.bind())
	animation.play("attack_1")
	time_start_attack = Time.get_ticks_msec()

func _physics_process(_delta: float) -> void:
	change_animation_finished()
	if is_animation_finished:
		if Input.is_action_pressed("interact"):
			index += 1
			if index > 3:
				transfrom_state(Player.State.MOVE)
				return
			animation.play("attack_%s" % [index])
			time_start_attack = Time.get_ticks_msec()
			is_animation_finished = false
		elif Time.get_ticks_msec() - time_start_attack > DURATION:
			transfrom_state(Player.State.MOVE)

func change_animation_finished() -> void:
	await animation.animation_finished
	is_animation_finished = true
	change_animation_finished()

func on_detect_area(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.get_hurt(player.atk)

func _exit_tree() -> void:
	detect_area.monitoring = false
