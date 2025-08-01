class_name Boar
extends BaseEnemy


@onready var attack: Attack = %Attack
@onready var find_playerarea: Area2D = %FindPlayerarea
@onready var animation: AnimationPlayer = $AnimationPlayer

func initialize() -> void:
	animation_player = animation
	find_player_area = find_playerarea
	self.add_to_group("Enemy")
