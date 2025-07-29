extends BaseNpc

const Laser = preload("res://scenes/none_player_character/Boss/boss_attack/laser/laser.tscn")
const BOSSGolem = preload("res://scenes/none_player_character/Boss/boss_golme.tscn")

var player:Player
@onready var attack_area: Area2D = $Body/Attack/AttackArea
@onready var health_progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var animation: AnimationPlayer = $AnimationPlayer

var is_miss:bool = false
var is_first_low :bool = false
var is_attack:bool = false
var laser_number:int = 3

func _ready() -> void:
	initialize()
	player = Global.player
	current_scale = body.scale.x
	_initialize_bar()
	
	MusicPlayer.play_bgm(preload("res://assets/Mp3/2. Shadowforge Convergence.mp3"))



func attack_1() -> void:
	for body in attack_area.get_overlapping_bodies():
		if body.has_method("get_hurt"):
			body.get_hurt(50, self, 10)


func attack_2() -> void:
	for i in range(laser_number):
		var laser = Laser.instantiate()
		laser.global_position = player.global_position - Vector2(randf_range(-400, 400), randf_range(800, 1000))
		laser.target_position = laser.global_position.direction_to(player.global_position)
		laser.is_oneshot = true
		get_parent().add_child(laser)
		await get_tree().create_timer(2.0).timeout
		

func control_hp() -> void:
	if health.current_hp < 150 && !is_first_low:
		is_attack = false
		is_first_low = true
		health.hp_recover_speed = 40
		miss()
	elif is_first_low && health.current_hp > 400 && is_miss:
		attack_range = 200
		attack_colddown = 2.5
		health.hp_recover_speed = 2.5
		is_miss = false
		animation.play("out")
		await animation.animation_finished
		switch_state(State.SPECIALGOLEM, NpcData.build().add_player(player))
		

func miss() -> void:
	attack_range = 600
	attack_colddown = 4.0
	if current_state_node:
		current_state_node.queue_free()
	var bossgolem = BOSSGolem.instantiate()
	animation.play("miss")
	is_miss = true
	await get_tree().create_timer(0.4).timeout
	bossgolem.global_position = global_position - Vector2(0,200)
	get_parent().add_child(bossgolem)
	loop_attack_2()
	
	
func loop_attack_2() -> void:
	await get_tree().create_timer(randf_range(4,6)).timeout	
	var laser = Laser.instantiate()
	laser.global_position = player.global_position - Vector2(randf_range(-400, 400), randf_range(800, 1000))
	laser.target_position = laser.global_position.direction_to(player.global_position)
	laser.is_oneshot = true
	get_parent().add_child(laser)
	
	await get_tree().create_timer(randf_range(2.0, 3.0)).timeout
	loop_attack_2()
	



func get_hurt(current_atk:float, _sourcer: Node2D, _number: int) -> void:
	if can_get_hurt:
		if !is_miss:
			can_get_hurt = false
			time_since_last_hurt = Time.get_ticks_msec()
			health.change_hp(-current_atk)
			start_blink()
	if health.is_hp_zero() && is_first_low:
		health.can_recover_hp = false
		health.current_hp = 0
		animation.play("miss")
		if current_state_node != null:
			current_state_node.queue_free()

func _process(delta: float) -> void:
	super._process(delta)
	control_hp()
	updata_bar()


func set_heading() -> void:
	if !is_attack:
		var direction := (player.global_position - global_position).normalized()
		if direction.x > 0:
			body.scale.x = current_scale
		else:
			body.scale.x = -current_scale

func _initialize_bar() -> void:
	health_progress_bar.max_value = health.max_hp
	health_progress_bar.value = health.max_hp


func updata_bar() -> void:
	health_progress_bar.value = health.current_hp

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		animation.play("start")
	elif event.is_action_pressed("2"):
		animation.play("attack_1")
	elif event.is_action_pressed("3"):
		animation.play("attack_2")

func initialize() -> void:
	animation_player = animation

func after_start() -> void:
	switch_state(State.SPECIALGOLEM, NpcData.build().add_player(player))

func _exit_tree() -> void:
	GameEvents.boss_death.emit()

func change_is_attack() -> void:
	is_attack = !is_attack
