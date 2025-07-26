# NPC基类，负责NPC的基础属性和行为
class_name BaseNpc
extends CharacterBody2D

const GRAVITY :float = 980.0
const DURATION_BETWEEN_HURT := 1000

enum Type {Enemy, Npc, Boss}
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
@export var knock_back: float

@onready var body: Node2D = %Body
@onready var health: Health = %Health
@onready var wall_ray_cast: RayCast2D = %WallRayCast
@onready var floor_ray_cast: RayCast2D = %FloorRayCast2D


var animation_player: AnimationPlayer = null
var find_player_area: Area2D = null


var heading :int = 1
var state_factory := NpcStateFactory.new()
var current_state : NpcState
var current_scale: float
var current_timer: Timer = null

var time_since_last_hurt:= Time.get_ticks_msec()

var can_get_hurt:bool = true

func _ready() -> void:
	initialize()
	current_scale = body.scale.x
	switch_state(State.MOVE)

func _process(delta: float) -> void:
	if type != Type.Npc:
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


func switch_state(state:State, data:NpcData = NpcData.new()) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player,find_player_area, floor_ray_cast, wall_ray_cast, data)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "NpcState" + str(state)
	call_deferred("add_child", current_state)


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

func initialize() -> void:
	pass

func on_save_game(saved_data:Array[SavedData]):
	if type == Type.Enemy:
		var my_data = SavedData.new()
		my_data.position = global_position
		my_data.current_hp = health.current_hp
		my_data.scene_path = scene_file_path
		
		saved_data.append(my_data)

func on_before_load_game():
	if type == Type.Enemy:
		get_parent().remove_child(self)
		queue_free()

func on_load_game(saved_data:SavedData):
	if type == Type.Enemy:
		global_position = saved_data.position
		health.current_hp = saved_data.current_hp
