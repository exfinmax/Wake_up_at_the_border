class_name NpcStateAttack
extends NpcState

var target : Node2D
var index : int = 1

func _enter_tree() -> void:
	target = npc_data.target
	attack_target()
	

func _physics_process(delta: float) -> void:
	if !npc.attack.can_useful_attack:
		froce_target(delta)
	

func froce_target(delta: float) -> void:
	var direction = npc.position.direction_to(target.position)
	if npc.position.distance_to(target.position) > 5:
		if direction.x > 0:
			npc.velocity.x = clampf(npc.velocity.x + npc.run_speed * delta, 0, npc.run_speed)
		elif direction.x < 0:
			npc.velocity.x = clampf(npc.velocity.x + -npc.run_speed * delta, -npc.run_speed, 0)
	else:
		npc.velocity.x = move_toward(npc.velocity.x, 0, delta)

func attack_target() -> void:
	if npc.attack.can_useful_attack:
		index = randi_range(1, npc.attack.max_atk_index)
		animation.play("attack_%s" % [str(index)])
		target.get_hurt(npc.attack.get_attack_number())
		await animation.animation_finished
		

	
