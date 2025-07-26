extends HSlider

@export var bus: StringName = "Master"

@onready var bus_index := AudioServer.get_bus_index(bus)

func _ready() -> void:
	value_changed.connect(func (v: float):
		MusicPlayer.set_volume(bus_index,v)
		Global.current_setting.set(str(bus), v)
	)
	
	if Global.current_setting != null:
		value = Global.current_setting.get(str(bus))
	else:
		value = MusicPlayer.get_volume(bus_index)
	

	
