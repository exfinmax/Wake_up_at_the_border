# NPC基类，负责NPC的基础属性和行为




class_name BaseNpc
extends CharacterBody2D

const GRAVITY :float = 980.0

enum Type {Enemy, Npc}
enum State {
	MOVE,
	AIR,
	ATTACK,
	HURT,
	SPECIAL,
}

@export_category("Move")
@export var walk_speed:float
@export var run_speed:float
@export var jump_speed:float
@export var firection:float

@export var type:Type

@onready var body: Node2D = %Body
@onready var health: Health = %Health


var animation_player: AnimationPlayer 
var heading :int = 1
var state_factory := NpcStateFactory.new()
var current_state : NpcState
var current_scale: float

var can_get_hurt:bool = true

func _ready() -> void:
	current_scale = scale.x
	switch_state(State.MOVE)

func _physics_process(delta: float) -> void:
	if type == Type.Enemy:
		set_heading()
		set_firction(delta)
		move_and_slide()



func get_hurt(current_atk:float) -> void:
	if can_get_hurt:
		health.change_hp(-current_atk)
		switch_state(State.HURT)
	
func switch_state(state:State, data:NpcData = NpcData.new()) -> void:
	pass

func set_heading() -> void:
	if velocity.x > 0:
		body.scale.x = current_scale
		
	elif velocity.x < 0:
		body.scale.x = -current_scale

func set_firction(delta:float) -> void:
	if !is_on_floor():
		velocity.y = velocity.y + GRAVITY * delta
	else:
		velocity.y = 0
