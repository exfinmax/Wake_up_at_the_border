class_name Golem
extends BaseNpc

@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var attack: Attack = %Attack
@onready var find_playerarea: Area2D = %FindPlayerarea
@onready var floor_ray_cast: RayCast2D = %FloorRayCast




func _ready() -> void:
	self.add_to_group("Enemy")
	animation_player = animation
	super._ready()

func switch_state(state:State, data:NpcData = NpcData.new()) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player,find_playerarea, floor_ray_cast, data)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "NpcState" + str(state)
	call_deferred("add_child", current_state)
