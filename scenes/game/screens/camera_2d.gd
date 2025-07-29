extends Camera2D

const DURATION_SHAKE := 120
const SHAKE_INSTANCE := 5

var shake_strength: float
var time_start_shake: float
var is_shaking := true
var has_boss := false
var current_shake_instance :float
var current_shake_duration :float

var player:Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.camera = self
	GameEvents.boss_death
	GameEvents.boss_start
	GameEvents.stage_changed.connect(on_load_over.bind())
	shake_strength = Global.current_setting.get("Strength")


func on_load_over() -> void:
	player = Global.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player != null && !has_boss:
		global_position = player.global_position
	
	
	if is_shaking:
		offset = Vector2(randf_range(-SHAKE_INSTANCE * shake_strength,SHAKE_INSTANCE * shake_strength), randf_range(-SHAKE_INSTANCE * shake_strength,SHAKE_INSTANCE * shake_strength))
		if Time.get_ticks_msec() - time_start_shake > DURATION_SHAKE:
				is_shaking = false
				offset = Vector2.ZERO


func shake() -> void:
	time_start_shake = Time.get_ticks_msec()
	is_shaking = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		shake()
