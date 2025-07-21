class_name Player
extends CharacterBody2D

const GRAVITY :float = 980

const DURATION_BETWEEN_HURT := 1200

enum State {
	ATTACK,
	MOVE,
	AIR,
	DEFEND,
	HURT,
}
@export_category("Attribute")
@export var atk: float
@export var crit: float
@export var max_energy: float
@export var energy_recover_speed: float
@export_category("Move")
@export var walk_speed:float
@export var run_speed:float
@export var jump_speed:float


var heading : int = 1

var state_factory := PlayerStateFactory.new()
var current_state : PlayerState
var current_energy :float

var can_be_hurt : bool = true
var can_recover_energy:bool = true
var is_defend:bool = false

var time_since_last_hurt:= Time.get_ticks_msec()

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var body: Node2D = %Body
@onready var detect_area: Area2D = %DetectArea
@onready var defend_area: Area2D = %DefendArea
@onready var health: Health = %Health
@onready var quest_conponent: Node2D = $QuestConponent
@onready var quest_manager: Node2D = $QuestManager



func _ready() -> void:
	Global.player = self
	switch_state(State.MOVE)


func _physics_process(delta: float) -> void:
	set_heading()
	recover_energy(delta)
	set_firction(delta)
	if Time.get_ticks_msec() - time_since_last_hurt > DURATION_BETWEEN_HURT:
		can_be_hurt = true
	move_and_slide()


func switch_state(state:State, data:PlayerData = PlayerData.new()) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player, detect_area, defend_area, quest_conponent, quest_manager, data)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "PlayerState" + str(state)
	call_deferred("add_child", current_state)
	
func get_hurt(current_atk:float) -> void:
	if !is_defend && can_be_hurt:
		can_be_hurt = false
		health.change_hp(-current_atk)
		time_since_last_hurt = Time.get_ticks_msec()
	switch_state(State.HURT)

func set_heading() -> void:
	if velocity.x > 0:
		body.scale.x = 2.3
		heading = 1
	elif velocity.x < 0:
		body.scale.x = -2.3
		heading = -1

func recover_energy(delta:float) -> void:
	if can_recover_energy:
		current_energy = clampf(current_energy + delta * energy_recover_speed, 0, max_energy)

func set_firction(delta:float) -> void:
	if !is_on_floor():
		velocity.y = velocity.y + GRAVITY * delta
	
