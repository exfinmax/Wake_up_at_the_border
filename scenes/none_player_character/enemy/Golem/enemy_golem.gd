class_name Golem
extends BaseEnemy

@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var attack: Attack = %Attack
@onready var find_playerarea: Area2D = %FindPlayerarea



func _ready() -> void:
	self.add_to_group("Enemy")
	initialize()
	current_scale = body.scale.x
	if Global.player:
		switch_state(State.ATTACK,NpcData.build().add_player(Global.player))
	else:
		switch_state(State.MOVE)

func initialize() -> void:
	animation_player = animation
	find_player_area = find_playerarea
