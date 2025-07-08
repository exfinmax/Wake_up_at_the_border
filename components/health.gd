class_name Health
extends Node2D

@export var max_hp:float
@export var hp_recover_speed: float
@export var can_recover_hp:bool 


@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

var current_hp:float

func _ready() -> void:
	texture_progress_bar.max_value = max_hp
	texture_progress_bar.value = max_hp
	current_hp = max_hp

func is_hp_zero() -> bool:
	if current_hp == 0:
		return true
	return false
func change_hp(number: int) -> void:
	current_hp = clampf(current_hp + number, 0, max_hp)
	texture_progress_bar.value = current_hp

func _physics_process(delta: float) -> void:
	if can_recover_hp:
		current_hp = clampf(current_hp + hp_recover_speed * delta, 0, max_hp)
