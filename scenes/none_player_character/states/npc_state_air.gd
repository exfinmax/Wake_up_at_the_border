# NPC空中状态脚本，负责NPC在空中时的行为




class_name NpcStateAir
extends NpcState





func _enter_tree() -> void:
	if npc.velocity.y > 0:
		animation.play("fall")
	elif npc.velocity.y < 0:
		animation.play("jump")

func _process(_delta: float) -> void:
	if npc.is_on_floor():
		transfrom_state(BaseEnemy.State.MOVE)


	
		
	
