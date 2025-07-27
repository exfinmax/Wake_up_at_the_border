extends Camera2D

const DURATION_SHAKE := 120
const SHAKE_INSTANCE := 5

var shake_strength: float
var time_start_shake: float
var is_shaking = true

func _ready() -> void:
	shake_strength = Global.current_setting.get("Strength")
	

func _process(_delta: float) -> void:
	if is_shaking:
		offset = Vector2(randf_range(-SHAKE_INSTANCE * shake_strength,SHAKE_INSTANCE * shake_strength), randf_range(-SHAKE_INSTANCE * shake_strength,SHAKE_INSTANCE * shake_strength))
		if Time.get_ticks_msec() - time_start_shake > DURATION_SHAKE:
				is_shaking = false
				offset = Vector2.ZERO


func shake() -> void:
	time_start_shake = Time.get_ticks_msec()
	is_shaking = true
	

func _exit_tree() -> void:
	enabled = false
