# 玩家主控制脚本
# 负责玩家的属性、状态切换、能量恢复、受伤处理等
class_name Player
extends CharacterBody2D

# 重力常量
const GRAVITY :float = 980
# 受伤后无敌持续时间（毫秒）
const DURATION_BETWEEN_HURT := 600

# 玩家状态枚举
enum State {
	ATTACK,
	MOVE,
	AIR,
	DEFEND,
	HURT,
}

# 属性导出，方便在编辑器中调整
@export_category("Attribute")
@export var max_energy: float
@export var energy_recover_speed: float
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
# 上次受伤时间戳
var time_since_last_hurt:= Time.get_ticks_msec()

# 组件和子节点引用
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var body: Node2D = %Body
@onready var interact_area: Area2D = %InteractArea  # 改名为InteractArea
@onready var defend_area: Area2D = %DefendArea
@onready var health_component: Health = %Health  # 统一命名为component
@onready var attack_component: Attack = %Attack  # 新增攻击组件引用
@onready var quest_conponent: Node2D = $QuestConponent
@onready var quest_manager: Node2D = $QuestManager

var current_timer: Timer = null

# 初始化，设置全局玩家引用，初始状态为MOVE
func _ready() -> void:
	Global.player = self
	switch_state(State.MOVE)

# 物理帧处理，处理能量恢复、摩擦、受伤判定、移动
func _physics_process(delta: float) -> void:
	set_heading()
	recover_energy(delta)
	set_firction(delta)
	move_and_slide()

# 切换玩家状态
func switch_state(state:State, data:PlayerData = PlayerData.new()) -> void:
	if current_state:
		current_state.queue_free()
	current_state = state_factory.change_state(state)
	current_state.setup(self, animation_player, interact_area, defend_area, quest_conponent, quest_manager, health_component, attack_component, data)
	current_state.state_change.connect(switch_state.bind())
	current_state.name = "PlayerState" + str(state)
	call_deferred("add_child", current_state)
	
# 受伤处理，减少血量，记录时间，触发闪烁
func get_hurt(current_atk:float) -> void:
	if !is_defend && can_be_hurt:
		can_be_hurt = false
		health_component.change_hp(-current_atk)
		time_since_last_hurt = Time.get_ticks_msec()
		start_blink() # 新增：受伤闪烁
	switch_state(State.HURT)

# 受伤闪烁效果
func start_blink():
	var blink_timer = Timer.new()
	current_timer = blink_timer
	blink_timer.wait_time = 0.1
	blink_timer.one_shot = false
	blink_timer.connect("timeout", Callable(self, "_on_blink_timeout"))
	add_child(blink_timer)
	blink_timer.start()
	$Body.modulate = Color(1,1,1,0.5) # 半透明

# 闪烁定时器回调，交替透明度，结束后恢复
func _on_blink_timeout():
	$Body.modulate.a = 1.0 if $Body.modulate.a < 1.0 else 0.5
	if Time.get_ticks_msec() - time_since_last_hurt > DURATION_BETWEEN_HURT:
		can_be_hurt = true
		$Body.modulate = Color(1,1,1,1)
		current_timer.queue_free()

# 设置朝向，根据速度自动翻转
func set_heading() -> void:
	if velocity.x > 0:
		body.scale.x = abs(body.scale.x)
	elif velocity.x < 0:
		body.scale.x = -abs(body.scale.x)

# 能量恢复逻辑
func recover_energy(delta: float) -> void:
	if can_recover_energy:
		current_energy = min(current_energy + energy_recover_speed * delta, max_energy)

# 摩擦力设置（可根据需要完善）
func set_firction(delta:float) -> void:
	if !is_on_floor():
		velocity.y = velocity.y + GRAVITY * delta
