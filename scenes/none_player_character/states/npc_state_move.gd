class_name NpcStateMove
extends NpcState

var rand_change: bool = false

func _enter_tree() -> void:
	player_detect_area.body_entered.connect(on_detect_player.bind())

func _physics_process(delta: float) -> void:
	ray_cast_detect()
	set_move_animation(delta)
	if npc.velocity.y != 0:
		transfrom_state(BaseNpc.State.AIR)
	
func ray_cast_detect() -> void:
	if not floor_ray_cast.is_colliding() || rand_change:
		npc.heading = -npc.heading
		npc.velocity.x = 0
		rand_change = false
		await get_tree().create_timer(randf_range(0.5,1)).timeout

func on_detect_player(player: Player) -> void:
	transfrom_state(BaseNpc.State.ATTACK,NpcData.build().add_player(player))

func set_rand_change() -> void:
	if !rand_change:
		rand_change = true if randf_range(0,1) > 0.8 else false
		await get_tree().create_timer(3).timeout
		set_rand_change()
		

func set_move_animation(delta:float) -> void:
	npc.velocity.x = clampf(npc.velocity.x + npc.walk_speed * delta * npc.heading, -npc.walk_speed, npc.walk_speed)
	if not npc.attack.can_useful_attack:
		if npc.velocity.x == 0:
			animation.play("idle")
		elif npc.velocity.x != 0:
			animation.play("move")
