class_name Bee
extends BaseEnemy

const FireBall := preload("res://scenes/none_player_character/enemy/Fly_ima/fire_ball.tscn")

@onready var attack: Attack = %Attack
@onready var find_playerarea: Area2D = %FindPlayerarea
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	is_fly = true
	initialize()
	current_scale = body.scale.x
	switch_state(State.AIR_MOVE)

func initialize() -> void:
	animation_player = animation
	find_player_area = find_playerarea
	self.add_to_group("Enemy")




func set_firction(_delta:float) -> void:
	pass
