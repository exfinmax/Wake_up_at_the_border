# 玩家主控制脚本
# 负责玩家的属性、状态切换、能量恢复、受伤处理等
class_name Player
extends CharacterBody2D

const Canying := preload("res://scenes/player/canying.tscn")

# 受伤后无敌持续时间（毫秒）
const DURATION_BETWEEN_HURT := 3000

# 玩家状态枚举
enum State {
	ATTACK,
	MOVE,
	AIR,
	DEFEND,
	HURT,
	AIR_KICK,
	AIR_ATK,
	LASER,
	DASH,
}

# 属性导出，方便在编辑器中调整
@export_category("Attribute")
@export var max_energy: float
@export var energy_recover_speed: float
@export var knock_back: float
@export_category("Skill")
@export var can_defend: bool
@export var can_double_jump:bool
@export var can_fly_kick:bool
@export var can_air_atk:bool
@export var can_laser:bool
@export var can_dash:bool
@export_category("Move")
@export var acceleration: float
@export var friction: float
@export var walk_speed:float
@export var run_speed:float
@export var jump_speed:float

# 朝向（1为右，-1为左）
var heading : int = 1
# 状态工厂，用于切换状态
var state_factory := PlayerStateFactory.new()
# 当前状态实例
var current_state : PlayerState
# 当前能量
var current_energy :float
# 是否可以受伤
var can_be_hurt : bool = true
# 是否可以恢复能量
var can_recover_energy:bool = true
# 是否处于防御状态
var is_defend:bool = false
var can_move: bool = true

var is_laser:bool = false
var apply_gravity: bool = true

# 上次受伤时间戳
var time_since_last_hurt:= Time.get_ticks_msec()

# 组件和子节点引用
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var body: Node2D = %Body
@onready var interact_area: Area2D = %InteractArea  # 改名为InteractArea
@onready var health_component: Health = %Health  # 统一命名为component
@onready var attack_component: Attack = %Attack  # 新增攻击组件引用
@onready var quest_conponent: Node2D = $QuestConponent
@onready var quest_manager: Node2D = $QuestManager
@onready var energy_progress_bar: TextureProgressBar = %EnergyProgressBar
@onready var health_progress_bar: TextureProgressBar = %HealthProgressBar
@onready var laser: RayCast2D = %Laser
@onready var animated_sprite_2d: AnimatedSprite2D = $Body/AnimatedSprite2D


var camera_2d: Camera2D


var current_timer: Timer = null

# 初始化，设置全局玩家引用，初始状态为MOVE
func _ready() -> void:
	camera_2d = Global.camera
	Global.player = self
	GameEvents.dialog_end.connect(exit_dialog.bind())
	_initialize_skill()
	switch_state(State.MOVE)

# 物理帧处理，处理能量恢复、摩擦、受伤判定、移动
func _process(delta: float) -> void:
	set_heading()
	recover_energy(delta)
	set_firction(delta)
	updata_bar()
	control_shader()
	move_and_slide()

# 切换玩家状态
func switch_state(state:State, data:PlayerData = PlayerData.new()) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player, interact_area, quest_conponent, quest_manager, health_component, attack_component, data)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "PlayerState" + str(state)
	call_deferred("add_child", current_state)
	
# 受伤处理，减少血量，记录时间，触发闪烁
func get_hurt(current_atk:float, sourcer: Node2D, lose_energy:float = 1) -> void:
	if is_laser:
		current_energy -= 2
	elif is_defend && current_energy >= lose_energy:
		current_energy -= lose_energy
		if sourcer.is_in_group("Enemy"):
			sourcer.knock_back *= 2
			sourcer.get_hurt(min(current_atk / 2, 20),self ,1)
			sourcer.knock_back /= 2
	elif can_be_hurt:
		can_be_hurt = false
		health_component.change_hp(-current_atk)
		start_blink() # 新增：受伤闪烁
		switch_state(State.HURT, PlayerData.build().add_body(sourcer))
	

# 受伤闪烁效果
func start_blink():
	var blink_timer = Timer.new()
	current_timer = blink_timer
	blink_timer.wait_time = 3.0
	blink_timer.one_shot = true
	time_since_last_hurt = Time.get_ticks_msec()
	blink_timer.connect("timeout", Callable(self, "_on_blink_timeout"))
	blink_timer.autostart = true
	call_deferred("add_child", blink_timer)
	$Body.modulate = Color(1,1,1,0.5) # 半透明

# 闪烁定时器回调，交替透明度，结束后恢复
func _on_blink_timeout():
	$Body.modulate.a = 1.0 if $Body.modulate.a < 1.0 else 0.5
	if Time.get_ticks_msec() - time_since_last_hurt > DURATION_BETWEEN_HURT:
		can_be_hurt = true
		$Body.modulate = Color(1,1,1,1)
		if current_timer != null: 
			current_timer.queue_free()

# 设置朝向，根据速度自动翻转
func set_heading() -> void:
	if !is_defend && !is_laser:
		if velocity.x > 0:
			body.scale.x = abs(body.scale.x)
			heading = 1
		elif velocity.x < 0:
			body.scale.x = -abs(body.scale.x)
			heading = -1

# 能量恢复逻辑
func recover_energy(delta: float) -> void:
	if can_recover_energy:
		current_energy = min(current_energy + energy_recover_speed * delta, max_energy)

# 摩擦力设置（可根据需要完善）
func set_firction(delta:float) -> void:
	if !is_on_floor() && apply_gravity:
		velocity += get_gravity() * delta
	



func updata_bar() -> void:
	health_progress_bar.max_value = health_component.max_hp
	health_progress_bar.value = health_component.current_hp
	energy_progress_bar.max_value = max_energy
	energy_progress_bar.value = current_energy

func reload_skill() -> void:
	can_defend = Global.player_skill[0]
	can_double_jump = Global.player_skill[1]
	can_air_atk = Global.player_skill[2]
	can_fly_kick = Global.player_skill[3]
	health_component.can_recover_hp = Global.player_skill[4]
	can_laser = Global.player_skill[5]
	can_dash = Global.player_skill[6]

func on_save_game(save_data:Array[SavedData]):
	var my_data :PlayerResource = PlayerResource.new()
	
	my_data.position = global_position
	my_data.current_atk = attack_component.atk
	my_data.current_energy = current_energy
	my_data.energy_recover_speed = energy_recover_speed
	my_data.max_energy = max_energy
	my_data.max_hp = health_component.max_hp
	my_data.player_skill = Global.player_skill
	my_data.current_hp = health_component.current_hp
	my_data.scene_path = scene_file_path
	my_data.quests = quest_manager.quests
	my_data.jump_speed = jump_speed
	
	save_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(save_data:SavedData):
	var saved_data:PlayerResource = save_data
	
	global_position = saved_data.position
	attack_component.atk = saved_data.current_atk
	current_energy = saved_data.current_energy
	energy_recover_speed = saved_data.energy_recover_speed
	max_energy = saved_data.max_energy
	health_component.max_hp = saved_data.max_hp
	Global.player_skill = saved_data.player_skill
	health_component.current_hp = saved_data.current_hp
	jump_speed = saved_data.jump_speed
	for quest in saved_data.quests.values():
		quest_manager.add_quest(quest)
	
	reload_skill()

func _initialize_skill() -> void:
	Global.player_skill[0] = can_defend
	Global.player_skill[1] = can_double_jump
	Global.player_skill[2] = can_air_atk
	Global.player_skill[3] = can_fly_kick
	Global.player_skill[4] = health_component.can_recover_hp
	Global.player_skill[5] = can_laser
	Global.player_skill[6] = can_dash

func control_shader() -> void:
	if is_defend || is_laser || !can_be_hurt:
		animated_sprite_2d.set_instance_shader_parameter("outline_width", 0.5)
	else:
		animated_sprite_2d.set_instance_shader_parameter("outline_width", 0)

func create_canying() -> void:
	if abs(velocity.x) > run_speed && can_dash:
		var c = Canying.instantiate()
		c.scale = Vector2(2.3,2.3) if body.scale.x > 0 else Vector2 (-2.3, 2.3)
		c.global_position = global_position - Vector2(0, 41.4)
		var properties := [
			"sprite_frames",
			"animation",
			"frame",
		]
		
		for i in properties:
			c.set(i, animated_sprite_2d.get(i))
		
		get_parent().add_child(c)
		
func exit_dialog(_id: String) -> void:
	can_move = true
