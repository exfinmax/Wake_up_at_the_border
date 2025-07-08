class_name NpcStateHurt
extends NpcState

const KNOCKBACK_VELOCITY :Vector2 = Vector2.LEFT

func _enter_tree() -> void:
	npc.velocity = KNOCKBACK_VELOCITY * npc.heading
	if npc.health.is_hp_zero():
		animation.play("death")
	else:
		animation.play("hurt")

func _physics_process(delta: float) -> void:
	await animation.animation_finished
	if npc.health.is_hp_zero():
		npc.queue_free()
	else:
		transfrom_state(BaseNpc.State.MOVE)
