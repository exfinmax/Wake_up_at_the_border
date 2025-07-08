class_name Player
extends RigidBody2D

enum State {
	ATTACK,
	MOVE,
	AIR,
	DEFEND,
	HURT,
	INTERACT,
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
var current_hp

var can_recover_energy:bool = true
var is_defend:bool = false

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var body: Node2D = %Body
@onready var detect_area: Area2D = %AttackArea
@onready var defend_area: Area2D = %DefendArea
@onready var health: Health = %Health



func _ready() -> void:
	switch_state(State.MOVE)


func _physics_process(delta: float) -> void:
	set_heading()
	recover_energy(delta)


func switch_state(state:State) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player, detect_area, defend_area)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "PlayerState" + str(state)
	call_deferred("add_child", current_state)
	
func get_hurt(current_atk:float) -> void:
	if !is_defend:
		health.show()
		health.change_hp(current_atk)
	switch_state(State.HURT)

func set_heading() -> void:
	if linear_velocity.x > 0:
		body.scale.x = 1
		heading = 1
	elif linear_velocity.x < 0:
		body.scale.x = -1
		heading = -1

func recover_energy(delta:float) -> void:
	if can_recover_energy:
		current_energy = clampf(current_energy + delta * energy_recover_speed, 0, max_energy)

	
