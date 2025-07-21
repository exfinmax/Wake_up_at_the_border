class_name Attack
extends Node2D

@export var atk: float
@export var crit: float
@export var max_atk_index: int

@onready var attack_area: Area2D = $AttackArea

var can_useful_attack:bool = false


func change_atk(number: int) -> void:
	atk = atk + number

func get_attack_number() -> float:
	if can_useful_attack:
		if randf_range(0,1) > crit:
			return atk * 2
		return atk
	return 0

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Player || body is BaseNpc:
		can_useful_attack = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is Player || body is BaseNpc:
		can_useful_attack = false
