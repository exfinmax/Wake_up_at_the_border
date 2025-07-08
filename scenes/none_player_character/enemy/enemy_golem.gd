class_name Golem
extends BaseNpc

@onready var animation: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	animation_player = animation
	super._ready()
