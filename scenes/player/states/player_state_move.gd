# 玩家移动状态脚本
# 负责处理玩家在地面上的移动、交互、对话、物品拾取等
class_name PlayerStateMove
extends PlayerState

const DURATION:float = 120

# 目标对象，玩家可以与之交互（NPC或物品）
var target: Node2D = null
# 是否为敌人，决定按键行为
var no_npc := true
# 是否正在对话中，防止重复触发
var is_in_dia := false
var is_in_air := false

var time_since_jump:float
# 进入节点树时的初始化
func _enter_tree() -> void:
	player.can_be_hurt = true
	# 连接交互区域的信号
	GameEvents.dialog_end.connect(exit_dialog.bind())
	interact_area.body_entered.connect(_on_interact_area_entered.bind())
	interact_area.area_entered.connect(_on_interact_area_entered.bind())
	interact_area.body_exited.connect(_on_interact_area_exited.bind())
	interact_area.area_exited.connect(_on_interact_area_exited.bind())
	# 播放初始动画
	animation.play("idle")

# 物理帧处理，处理输入和动画切换
func _process(delta: float) -> void:
	if !is_in_dia:
		_handle_movement_input(delta)
		_update_animation()
		# 如果y方向有速度，切换到空中状态
		if player.velocity.y != 0:
			if Time.get_ticks_msec() - time_since_jump > DURATION:
				transfrom_state(Player.State.AIR)
		else:
			time_since_jump = Time.get_ticks_msec()

# 处理玩家输入
func _handle_movement_input(delta:float) -> void:
	set_friction(delta)
	# 跳跃输入
	if Input.is_action_just_pressed("ui_up"):
		player.velocity.y = -player.jump_speed
		transfrom_state(Player.State.AIR)
	# 攻击输入（仅对敌人有效）
	elif player.can_dash && Input.is_action_just_pressed("interact") && (Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left")) && player.current_energy > 2:
		transfrom_state(Player.State.DASH)
	elif Input.is_action_just_pressed("interact") && no_npc:
		transfrom_state(Player.State.ATTACK)
	# 防御输入
	elif Input.is_action_just_pressed("ui_down") && player.current_energy > 1 && player.can_defend:
		transfrom_state(Player.State.DEFEND)

# 根据速度切换动画
func _update_animation() -> void:
	if absf(player.velocity.x) > player.walk_speed:
		animation.play("run")
	elif player.velocity == Vector2.ZERO:
		animation.play("idle")
	elif absf(player.velocity.x) <= player.walk_speed:
		animation.play("walk")

# 交互区域检测处理
func _on_interact_area_entered(body) -> void:
	if body.is_in_group("NPC") || body.is_in_group("Item"):
		target = body
		no_npc = false


# 离开交互区域
func _on_interact_area_exited(body) -> void:
	if body == target:
		target = null
		no_npc = true

# 处理输入事件（如对话、物品交互、任务日志）
func _input(event: InputEvent) -> void:
	# 如果不在对话中
	if not is_in_dia:
		# 按下交互键
		if event.is_action_pressed("interact"):
			if target:
				# 与NPC对话
				if target.is_in_group("NPC"):
					is_in_dia = true
					animation.play("idle")
					target.start_dialogue()
					quest_conponent.check_quest_objectives(target.npc_id, "talk_to")
				# 拾取物品
				if target.is_in_group("Item"):
					if quest_conponent.is_item_needed(target.item_id):
						quest_conponent.check_quest_objectives(target.item_id, "collection", target.item_quantity)
						target.free()
						GameEvents.quest_complete.emit()
					else:
						print("Item not needed for any active quest.")
				# 停止移动
				player.velocity = Vector2.ZERO
	# 按下任务日志键，显示/隐藏任务日志
	if event.is_action_pressed("quest_menu"):
		quest_manager.show_hide_log()

# 设置摩擦力和加速度，实现平滑移动
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

func exit_dialog() -> void:
	is_in_dia = false
