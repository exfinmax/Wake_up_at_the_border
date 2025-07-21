class_name PlayerStateMove
extends PlayerState

var target: Node2D = null
var is_enemy := true
var is_in_dia := false

func _enter_tree() -> void:
	detect_area.body_entered.connect(on_detect_area.bind())
	detect_area.body_exited.connect(on_detect_area.bind())
	animation.play("idle")

func _physics_process(delta: float) -> void:
	unhand_input(delta)
	change_ani()
	if player.velocity.y != 0:
		transfrom_state(Player.State.AIR)
	
func unhand_input(delta:float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		player.velocity.y = -player.jump_speed
		transfrom_state(Player.State.AIR)
	elif Input.is_action_just_pressed("interact") && is_enemy:
		transfrom_state(Player.State.ATTACK)
	elif Input.is_action_just_pressed("ui_down"):
		transfrom_state(Player.State.DEFEND)
	elif Input.is_action_pressed("ui_left"):
		player.velocity.x = clampf(player.velocity.x + -player.walk_speed * delta * 10, -player.run_speed, 0)
	elif Input.is_action_pressed("ui_right"):
		player.velocity.x = clampf(player.velocity.x + player.walk_speed * delta * 10, 0, player.run_speed)

func change_ani() -> void:
	if absf(player.velocity.x) > player.walk_speed:
		animation.play("run")
	elif player.velocity == Vector2.ZERO:
		animation.play("idle")
	elif absf(player.velocity.x) <= player.walk_speed:
		animation.play("walk")


func on_detect_area(body: Node2D) -> void:
	if body.is_in_group("NPC") || body.is_in_group("Item"):
		is_enemy = !is_enemy
		target = body if not is_enemy else null
	 
func _input(event: InputEvent) -> void:
	if not is_in_dia:
		if event.is_action_pressed("interact"):
			if target:
				if target.is_in_group("NPC"):
					target.start_dialogue()
					is_in_dia = true
					quest_conponent.check_quest_objectives(target.npc_id, "talk_to")
				if target.is_in_group("Item"):
					if quest_conponent.is_item_needed(target.item_id):
						quest_conponent.check_quest_objectives(target.item_id, "collection", target.item_quantity)
						target.queue_free()
					else:
						print("Item not needed for any active quest.")
				player.velocity = Vector2.ZERO
				
			
	if event.is_action_pressed("quest_menu"):
		quest_manager.show_hide_log()
