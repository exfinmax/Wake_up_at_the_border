# 攻击状态
class_name PlayerStateAttack
extends PlayerState

const DURATION := 600  # 攻击持续时间（毫秒）
const MAX_COMBO := 3   # 最大连击数

var time_start_attack: int
var combo_index := 1
var is_animation_finished := false



func _enter_tree() -> void:
	_start_attack()

func _process(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.friction * delta * 30)
	change_animation_finished()
	
	if is_animation_finished:
		if Input.is_action_pressed("interact"):
			_continue_combo()
		elif Time.get_ticks_msec() - time_start_attack > DURATION:
			_end_attack()

# 动画结束检测
func change_animation_finished() -> void:
	await animation.animation_finished
	is_animation_finished = true
	change_animation_finished()

# 攻击判定


# 开始攻击
func _start_attack() -> void:
	animation.play("attack_1")
	time_start_attack = Time.get_ticks_msec()
	if attack_component.is_useful_attack:
		player.current_energy += 1


# 继续连击
func _continue_combo() -> void:
	combo_index += 1
	if combo_index > MAX_COMBO:
		_end_attack()
		return
		
	animation.play("attack_%s" % [combo_index])
	time_start_attack = Time.get_ticks_msec()
	is_animation_finished = false
	if attack_component.is_useful_attack:
		player.current_energy += 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down") && player.current_energy > 1:
		player.current_energy -= 1
		transfrom_state(Player.State.DEFEND)


# 结束攻击
func _end_attack() -> void:
	transfrom_state(Player.State.MOVE)
