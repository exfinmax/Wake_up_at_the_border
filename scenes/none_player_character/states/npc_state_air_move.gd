class_name NpcStateAirMove
extends NpcState

var can_attack:bool = true

var target : Node2D
# 攻击动画索引
var max_index : int 
var is_attack: bool = false


var all_delta: float
var attack_timer: float = 0.0  # 攻击计时器
var attack_combo: int = 1  # 连击计数

func _enter_tree() -> void:
	player_detect_area.body_entered.connect(on_player_deteccted.bind())



func on_player_deteccted(player: Node2D) -> void:
	npc_data.target = player

func _physics_process(delta: float) -> void:
	attack_timer -= delta
	all_delta += delta
	if npc_data.target != null:
		var distance:float = npc.global_position.distance_squared_to(npc_data.target.global_position)
		if distance > (npc.attack_range * npc.attack_range) && !is_attack:
			var direction = npc.global_position.direction_to(npc_data.target.global_position - Vector2(0, 50))
			npc.velocity = npc.velocity.move_toward(direction * npc.run_speed, npc.firection * delta)
			set_ani()
		else:
			_perform_attack()
	else:
		npc.velocity = Vector2(sin(all_delta) * npc.run_speed, cos(all_delta))


func _perform_attack() -> void:
	npc.velocity = Vector2.ZERO
	
	if attack_timer <= 0 and can_attack:
		# 开始攻击动画
		is_attack = true
		animation.play("attack")
		attack_timer = npc.attack_colddown
		can_attack = false
		
		
		# 等待动画完成
		await animation.animation_finished
		
		# 处理连击
		attack_combo = (attack_combo % 3) + 1
		is_attack = false
		can_attack = true
		# 随机决定是否后退拉开距离

func set_ani() -> void:
	if npc.velocity != Vector2.ZERO:
		animation.play("fly")
	
