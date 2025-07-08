class_name BaseNpc
extends CharacterBody2D

const GRAVITY :float = 980.0

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

@onready var body: Node2D = %Body
@onready var attack: Attack = %Attack
@onready var health: Health = %Health
@onready var find_playerarea: Area2D = %FindPlayerarea
@onready var floor_ray_cast: RayCast2D = %FloorRayCast

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
	set_heading()
	set_move_animation()
	set_firction(delta)
	move_and_slide()

func switch_state(state:State, data:NpcData = NpcData.new()) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player,find_playerarea, floor_ray_cast, data)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "NpcState" + str(state)
	call_deferred("add_child", current_state)

func get_hurt(current_atk:float) -> void:
	if can_get_hurt:
		health.change_hp(-current_atk)
		switch_state(State.HURT)
	

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

func set_move_animation() -> void:
	if not attack.can_useful_attack:
		if velocity.x == 0:
			animation_player.play("idle")
		elif velocity.y < 0:
			animation_player.play("fall")
		elif velocity.x != 0:
			animation_player.play("move")
