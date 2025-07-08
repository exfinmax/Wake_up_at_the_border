class_name NpcStateMove
extends NpcState

func _enter_tree() -> void:
	player_detect_area.body_entered.connect(on_detect_player.bind())

func _physics_process(delta: float) -> void:
	ray_cast_detect()
	npc.velocity.x = clampf(npc.velocity.x + npc.walk_speed * delta * npc.heading, -npc.walk_speed, npc.walk_speed)

func ray_cast_detect() -> void:
	if not floor_ray_cast.is_colliding():
		npc.heading = -npc.heading
		npc.velocity.x = 0

func on_detect_player(player: Player) -> void:
	transfrom_state(BaseNpc.State.ATTACK,NpcData.build().add_player(player))
