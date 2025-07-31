# 空中状态
class_name PlayerStateAir
extends PlayerState

var is_fall:bool = false
var is_double_jump:bool = false

func _enter_tree() -> void:
	animation.play("jump")

func _process(delta: float) -> void:
	# 下落时切换动画
	set_friction(delta)
	if player.velocity.y > 0 && !is_fall:
		animation.play("fall")
		is_fall = true
	if player.can_double_jump && !is_double_jump && Input.is_action_just_pressed("ui_up") && player.current_energy > 1:
		player.current_energy -= 1
		animation.play("double_jump")
		is_double_jump = true
		player.velocity.y = -player.jump_speed
	
	
	if Input.is_action_pressed("ui_down") && Input.is_action_just_pressed("interact") && player.current_energy > 4 && player.can_air_atk:
		transfrom_state(Player.State.AIR_ATK)
	elif player.can_dash && Input.is_action_just_pressed("interact") && (Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left")) && player.current_energy > 2:
		transfrom_state(Player.State.DASH)
	elif player.can_fly_kick && Input.is_action_just_pressed("interact") && player.current_energy > 6:
		transfrom_state(Player.State.AIR_KICK)
	
	# 落地切回移动
	elif player.is_on_floor():
		transfrom_state(Player.State.MOVE)

func set_friction(delta:float) -> void:
	# 获取左右输入
	var x_input: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# 根据是否有输入决定使用加速度还是摩擦力
	var velocity_weight: float = delta * (player.acceleration if x_input else player.friction)
	# 平滑插值速度
	player.velocity.x = lerpf(player.velocity.x, x_input * player.run_speed, velocity_weight)
	# 速度很小时直接归零，防止滑动
	if absf(player.velocity.x) < 2.0:
		player.velocity.x = 0.0
