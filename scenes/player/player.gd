class_name Player
extends RigidBody2D

enum State {
	IDLE,
	MOVE,
	AIR,
}


@export var walk_speed:float
@export var run_speed:float
@export var jump_speed:float


var heading : int = 1

var state_factory := PlayerStateFactory.new()
var current_state : PlayerState




@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var body: Node2D = %Body
@onready var floor_ray_cast: RayCast2D = %FloorRayCast

func _ready() -> void:
	switch_state(State.MOVE)


func _physics_process(delta: float) -> void:
	unhand_input()
	set_heading()
	
	

func unhand_input() -> void:
	if Input.is_action_just_pressed("ui_left"):
		switch_state(State.IDLE)
	if Input.is_action_pressed("ui_left"):
		heading = -1
	elif Input.is_action_just_released("ui_left"):
		heading = 1

func switch_state(state:State) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player, floor_ray_cast)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "PlayerState" + str(state)
	call_deferred("add_child", current_state)
	


func set_heading() -> void:
	if linear_velocity.x > 0:
		body.scale.x = 1
	elif linear_velocity.x < 0:
		body.scale.x = -1



	
