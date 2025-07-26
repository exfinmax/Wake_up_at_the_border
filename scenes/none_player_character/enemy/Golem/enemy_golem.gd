class_name Golem
extends BaseNpc

@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var attack: Attack = %Attack
@onready var find_playerarea: Area2D = %FindPlayerarea





func _ready() -> void:
	self.add_to_group("Enemy")
	super._ready()

func initialize() -> void:
	animation_player = animation
	find_player_area = find_playerarea
