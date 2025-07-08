class_name BaseNpc
extends CharacterBody2D

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
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var floor_ray_cast: RayCast2D = %FloorRayCast

var heading :int = 1
var state_factory := NpcStateFactory.new()
var current_state : NpcState
var self_data: NpcData

var can_get_hurt:bool = true

func _ready() -> void:
	switch_state(State.MOVE)

func _physics_process(delta: float) -> void:
	set_heading()
	set_move_animation()
	set_floor_firction()

func switch_state(state:State) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player,find_playerarea, floor_ray_cast, self_data)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "NpcState" + str(state)
	call_deferred("add_child", current_state)

func get_hurt(current_atk:float) -> void:
	if can_get_hurt:
		health.change_hp(-current_atk)
		switch_state(State.HURT)
	

func set_heading() -> void:
	if velocity.x > 0:
		body.scale.x = 1
		
	elif velocity.x < 0:
		body.scale.x = -1

func set_floor_firction() -> void:
	if floor_ray_cast.is_colliding():
		velocity.x = clampf(velocity.x - firection, 0, run_speed)

func set_move_animation() -> void:
	if velocity.x == 0:
		animation_player.play("idle")
	elif velocity.y != 0:
		animation_player.play("fall")
	elif velocity.x != 0:
		animation_player.play("move")
