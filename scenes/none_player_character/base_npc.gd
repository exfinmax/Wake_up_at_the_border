# NPC基类，负责NPC的基础属性和行为




class_name BaseNpc
extends CharacterBody2D

const GRAVITY :float = 980.0
const DURATION_BETWEEN_HURT := 1000

enum Type {Enemy, Npc}
enum State {
	MOVE,
	AIR,
	ATTACK,
	HURT,
	SPECIAL,
}

@export_category("BaseNpc")
@export var type:Type
@export var walk_speed:float
@export var run_speed:float
@export var jump_speed:float
@export var firection:float

@export_category("Enemy")
@export var attack_range: float
@export var chase_range: float
@export var attack_colddown: float

@onready var body: Node2D = %Body
@onready var health: Health = %Health


var animation_player: AnimationPlayer 
var heading :int = 1
var state_factory := NpcStateFactory.new()
var current_state : NpcState
var current_scale: float
var current_timer: Timer = null

var time_since_last_hurt:= Time.get_ticks_msec()

var can_get_hurt:bool = true

func _ready() -> void:
	current_scale = body.scale.x
	switch_state(State.MOVE)

func _process(delta: float) -> void:
	if type == Type.Enemy:
		set_heading()
		set_firction(delta)
		move_and_slide()



func get_hurt(current_atk:float, sourcer: Node2D) -> void:
	if can_get_hurt:
		can_get_hurt = false
		health.change_hp(-current_atk)
		start_blink()
		switch_state(State.HURT, NpcData.build().add_player(sourcer))

func start_blink():
	var blink_timer = Timer.new()
	current_timer = blink_timer
	blink_timer.wait_time = 0.1
	blink_timer.one_shot = false
	blink_timer.connect("timeout", Callable(self, "_on_blink_timeout"))
	add_child(blink_timer)
	blink_timer.start()
	$Body.modulate = Color(1,1,1,0.5) # 半透明

# 闪烁定时器回调，交替透明度，结束后恢复
func _on_blink_timeout():
	$Body.modulate.a = 1.0 if $Body.modulate.a < 1.0 else 0.5
	if Time.get_ticks_msec() - time_since_last_hurt > DURATION_BETWEEN_HURT:
		can_get_hurt = true
		$Body.modulate = Color(1,1,1,1)
		current_timer.queue_free()


func switch_state(_state:State, _data:NpcData = NpcData.new()) -> void:
	pass

func set_heading() -> void:
	if can_get_hurt:
		if velocity.x > 0:
			body.scale.x = current_scale
		elif velocity.x < 0:
			body.scale.x = -current_scale

func set_firction(delta:float) -> void:
	if !is_on_floor():
		velocity.y = velocity.y + GRAVITY * delta
	else:
		velocity.y = 0
