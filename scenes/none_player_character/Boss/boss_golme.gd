class_name BossGolem
extends BaseEnemy



const EnemyGolem = preload("res://scenes/none_player_character/enemy/Golem/enemy_golem.tscn")
const ATTACK_1 = preload("res://scenes/none_player_character/Boss/boss_attack/attack_1.tscn")
const ATTACK_3 = preload("res://scenes/none_player_character/Boss/boss_attack/attack_3.tscn")


@onready var attack: Attack = $Body/Attack
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var health_progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var npc_sprite: Sprite2D = $Body/NpcSprite

var player:Player
var is_first_low :bool = false
var is_defend:bool = false
var death_index:int = 1
var is_death:bool = false

func _ready() -> void:
	_initialize_bar()
	initialize()
	player = Global.player
	current_scale = body.scale.x
	await animation.animation_finished
	
	Global.camera.shake(3)
	MusicPlayer.play_bgm(preload("res://assets/Mp3/FEARMONGER.mp3"))
	


func get_hurt(current_atk:float, _sourcer: Node2D, number: int) -> void:
	if can_get_hurt:
		if !is_defend:
			can_get_hurt = false
			time_since_last_hurt = Time.get_ticks_msec()
			var direction = sign(global_position - player.global_position)
			velocity = Vector2(knock_back * number * direction.x, -100)
			animation.play("hurt")
			health.change_hp(-current_atk)
			start_blink()
				
		else:
			can_get_hurt = false
			time_since_last_hurt = Time.get_ticks_msec()
			start_blink()
			health.change_hp(-current_atk / 2)
			rand_attack()
	if health.is_hp_zero():
		if current_state_node != null:
			current_state_node.queue_free()
		health.can_recover_hp = false
		health.current_hp = 0
		is_death = true
		death()
		

func _process(delta: float) -> void:
	super._process(delta)
	updata_bar()
	control_hp()
	

func control_hp() -> void:
	if health.current_hp < 60 && !is_first_low:
		is_defend = true
		is_first_low = true
		health.can_recover_hp = true
		defend()
	elif is_first_low && health.current_hp > 200 && is_defend:
		health.hp_recover_speed = 4.0
		is_defend = false
		animation.play("defend_over")
		await animation.animation_finished
		switch_state(State.SPECIAL, NpcData.build().add_player(player))
	elif is_death:
		health.current_hp = 0
		health.can_recover_hp = false
		set_process(false)
		is_defend = false
		health.current_hp = 0
		death()

func initialize() -> void:
	animation_player = animation

func attack_1() -> void:
	for i in randi_range(2,4):
		var attack1 = ATTACK_1.instantiate()
		attack1.global_position = player.global_position - Vector2(0, 50)
		get_parent().add_child(attack1)
		await get_tree().create_timer(0.6).timeout
	if !is_defend || !is_death:
		animation.play("attack_1_end")
	
	
	

func attack_2() -> void:
	var golem = EnemyGolem.instantiate()
	golem.global_position = player.global_position - Vector2(0, 400)
	golem.chase_range = 1000
	golem.switch_state(State.ATTACK,NpcData.build().add_player(player))
	get_parent().call_deferred("add_child", golem)

func attack_3() -> void:
	for i in randi_range(3,5):
		var attack3 = ATTACK_3.instantiate()
		attack3.set_velocity(player.global_position)
		attack3.global_position = self.global_position - Vector2(randf_range(-100, 100), 70)
		get_parent().call_deferred("add_child", attack3)
	

func defend() -> void:
	if current_state_node != null:
		current_state_node.queue_free()
	velocity = Vector2.ZERO
	if animation.is_playing():
		animation.play("defend")
	animation.play("defend")


func death() -> void:
	velocity = Vector2.ZERO
	animation.play("death_1")
	await animation.animation_finished


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start" || anim_name == "hurt":
		switch_state(State.SPECIAL, NpcData.build().add_player(Global.player))
	elif anim_name.begins_with("death"):
		death_index = clampi(death_index + 1, 2, 4)
		animation.play("death_%s" % str(death_index))
		GameEvents.enemy_death.emit(self)

func set_heading() -> void:
	if player != null:
		var direction := (player.global_position - global_position).normalized()
		if direction.x > 0:
			body.scale.x = current_scale
		else:
			body.scale.x = -current_scale

func rand_attack() -> void:
	var number = randi_range(0,9)
	if number < 5:
		attack_2()
	elif number < 8:
		attack_1()
	else:
		attack_3()


func _initialize_bar() -> void:
	health_progress_bar.max_value = health.max_hp
	health_progress_bar.value = health.max_hp



func updata_bar() -> void:
	health_progress_bar.value = health.current_hp




func _exit_tree() -> void:
	GameEvents.boss_death.emit()
