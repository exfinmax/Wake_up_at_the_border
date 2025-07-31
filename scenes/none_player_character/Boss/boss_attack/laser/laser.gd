extends RayCast2D

@export var color:Color
@export var duration: float
@export var is_process_check: bool = false

var tween: Tween = null
var is_casting:bool = false
var laser_width: float = 50#基础宽度 
var start_distance: float = 30.0 #起点
var max_length: float = 3000.0 #长度
var cast_speed: float = 3000.0 #速度
var extend_time: float = 0.15 #充能时间
var pulse_amplitude: float = 0.2 #正弦浮动幅度 
var pulse_speed: float = 3.0#正弦浮动速度
var pulse_time: float  #正弦浮动计时器
var is_oneshot: bool = false
var body_in_shape: bool = false
var current_body:Array = []



@onready var beam: Line2D = $Beam
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


func init(config: Dictionary) -> void:
	beam.visible = false
	beam.modulate = color
	beam.rotation = 0.0
	beam.points = [Vector2.ZERO, Vector2.DOWN]
	laser_width = config.get("width")
	pulse_amplitude = config.get("pulse_amplitude")
	pulse_speed = config.get("pulse_speed")
	

func _ready() -> void:
	area_2d.body_entered.connect(on_body_entered.bind())
	

	

func set_is_casting(new_status: bool) -> void:
	if is_casting == new_status:
		return
	is_casting = new_status
	
	if is_casting:
		collision_shape_2d.rotation = collision_shape_2d.position.angle_to_point(target_position)
		set_line_point(0, target_position)
		set_line_point(1, target_position)
		
		pulse_time = 0.0
		appear()
	
	

func set_line_point(index: int, _position: Vector2) -> void:
	if index < beam.points.size():
		var points = beam.points
		points.set(index, _position)
		beam.points = points

func _process(delta: float) -> void:
	area_2d.monitoring = visible
	if visible:
		set_line_point(1, target_position)
		area_2d.position = beam.points[1]
		var pulse = sin(pulse_time * pulse_speed * TAU) * pulse_amplitude
		beam.width = laser_width * (1.0 + pulse)
		
		if is_casting:
			pulse_time += delta
			collision_shape_2d.rotation = collision_shape_2d.position.angle_to_point(target_position)
			collision_shape_2d.shape.size.x = target_position.y
			target_position = target_position.move_toward(target_position.normalized() * max_length, cast_speed * delta)
		if body_in_shape:
			for body in current_body:
				if body != null && body.has_method("get_hurt"):
					body.get_hurt(40, self, 3)
		if pulse_time > duration * 1.5:
			pulse_time = 0
			disappear()
	else:
		target_position = Vector2.ZERO

func appear() -> void:
	beam.show()
	if tween && tween.is_running():
		tween.kill()
	
	beam.self_modulate = Color.TRANSPARENT
	beam.visible = true
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(beam, "width", laser_width * 2, extend_time * 0.5)
	
	tween.parallel()	
	tween.tween_property(beam, "self_modulate:a", 1.0, extend_time * 0.5)
	
	tween.chain()
	tween.tween_property(beam, "width", laser_width, extend_time)
	
	
func disappear() -> void:
	if tween && tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(beam, "width", 0.0, extend_time)
	
	tween.parallel()
	tween.tween_property(beam, "self_modulate:a", 0.0, extend_time)
	tween.chain()
	
	body_in_shape = false
	current_body = []
	beam.points = [Vector2.ZERO, Vector2.DOWN]
	if is_oneshot:
		queue_free()
	
func on_body_entered(body: Node2D) -> void:
	await  get_tree().create_timer(0.1).timeout
	if is_process_check:
		body_in_shape = true
		current_body.append(body)
	
	if body.has_method("get_hurt"):
		body.get_hurt(15, self, 3)
	await get_tree().create_timer(duration).timeout
	disappear()
	
