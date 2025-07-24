# NPC空中状态脚本，负责NPC在空中时的行为




class_name NpcStateAir
extends NpcState

const GROUND_TIME := 300

var time_since_ground := Time.get_ticks_msec()
var is_fake_ground :bool = true

func _enter_tree() -> void:
	if npc.velocity.y > 0:
		animation.play("fall")
	elif npc.velocity.y < 0:
		animation.play("jump")

func _process(_delta: float) -> void:
	if npc.velocity.y == 0:
		transfrom_state(BaseNpc.State.MOVE)


	
		
	
