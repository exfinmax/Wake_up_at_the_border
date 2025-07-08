class_name NpcStateAttack
extends NpcState

var target : Node2D
var index : int = 1

func _enter_tree() -> void:
	target = npc_data.target
	

func _physics_process(delta: float) -> void:
	if !npc.attack.can_useful_attack:
		froce_target(delta)
	attack_target()

func froce_target(delta: float) -> void:
	var direction = npc.position.direction_to(target.position)
	if direction.x > 0:
		npc.velocity.x = clampf(npc.velocity.x + npc.run_speed * delta, 0, npc.run_speed)
	elif direction.x < 0:
		npc.velocity.x = clampf(npc.velocity.x + -npc.run_speed * delta, -npc.run_speed, 0)
		
func attack_target() -> void:
	if npc.attack.can_useful_attack:
		animation.play("attack_%s" % [str(index)])
		target.get_hurt(npc.attack.get_attack_number())
			
		await animation.animation_finished
		
