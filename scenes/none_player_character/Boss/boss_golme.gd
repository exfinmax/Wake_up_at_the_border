class_name BossGolem
extends BaseNpc



const EnemyGolem = preload("res://scenes/none_player_character/enemy/Golem/enemy_golem.tscn")

@onready var attack: Attack = $Body/Attack
@onready var attack_fx: Sprite2D = $Body/AttackFX
@onready var animation: AnimationPlayer = $AnimationPlayer

var player:Player
var is_first_low :bool = false
var is_death:bool = false
var death_index:int = 1

func _ready() -> void:
	player = Global.player
	initialize()
	current_scale = body.scale.x
	


func get_hurt(current_atk:float, sourcer: Node2D) -> void:
	if can_get_hurt:
		can_get_hurt = false
		health.change_hp(-current_atk)
		start_blink()

func _process(delta: float) -> void:
	super._process(delta)
	control_hp()
	if health.is_hp_zero() && !is_death:
		health.can_recover_hp = false
		current_state_node.queue_free()
		is_death = true
		death()

func control_hp() -> void:
	if health.current_hp < 50 && !is_first_low:
		is_first_low = true
		health.can_recover_hp = true
	elif is_first_low && health.current_hp > 120:
		health.can_recover_hp = false

func initialize() -> void:
	animation_player = animation

func attack_1() -> void:
	for i in randi_range(1,3):
		attack.global_position = player.global_position
		attack_fx.global_position = player.global_position - Vector2(0, 30)
		animation.play("attack_1_fx")
		await animation.animation_finished
	animation.play("attack_1_end")

func attack_2() -> void:
	var golem = EnemyGolem.instantiate()
	golem.global_position = player.global_position - Vector2(0, 320)
	golem.switch_state(State.ATTACK,NpcData.build().add_player(player))
	get_parent().add_child(golem)

func attack_3() -> void:
	pass

func defend() -> void:
	pass

func death() -> void:
	animation.play("death_1")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start":
		switch_state(State.SPECIALGOLEM, NpcData.build().add_player(player))
	elif anim_name.begins_with("death"):
		death_index += 1
		animation.play("death_%s" % str(death_index))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		animation.play("start")

func _exit_tree() -> void:
	GameEvents.boss_death.emit()
