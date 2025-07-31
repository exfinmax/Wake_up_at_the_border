class_name FlyIma
extends BaseNpc

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

func fire_ball() -> void:
	var fire_ball = FireBall.instantiate()
	fire_ball.global_position = self.global_position + Vector2(0, -50)
	fire_ball.set_velocity(Global.player.global_position)
	get_parent().call_deferred("add_child", fire_ball)
	

func set_firction(_delta:float) -> void:
	pass
