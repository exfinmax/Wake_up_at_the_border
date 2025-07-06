class_name Player
extends RigidBody2D

enum State {
	ATTACK,
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
@onready var attack_area: Area2D = %AttackArea


func _ready() -> void:
	switch_state(State.MOVE)


func _physics_process(delta: float) -> void:
	set_heading()


func switch_state(state:State) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player, attack_area)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "PlayerState" + str(state)
	call_deferred("add_child", current_state)
	


func set_heading() -> void:
	if linear_velocity.x > 0:
		body.scale.x = 1
		heading = 1
	elif linear_velocity.x < 0:
		body.scale.x = -1
		heading = -1



	
