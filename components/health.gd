class_name Health
extends Node2D

@export var max_hp:int
@export var current_hp:int
@export var hp_recover_speed: float

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar


func get_current_hp() -> void:
	print(current_hp)

func change_hp(number: int) -> void:
	current_hp = clampi(current_hp + number, 0, max_hp)
