extends Camera2D



var player:Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.stage_changed.connect(on_load_over.bind())


func on_load_over() -> void:
	player = Global.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		enabled = true
		global_position = player.global_position
