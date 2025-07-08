class_name Attack
extends Node2D

@export var atk: float
@export var crit: float

@onready var attack_area: Area2D = $AttackArea

var can_useful_attack:bool = false


func change_atk(number: int) -> void:
	atk = atk + number

func get_attack_number() -> int:
	if can_useful_attack:
		if randf_range(0,1) > crit:
			return atk * 2
		return atk
	return 0

func _on_attack_area_body_entered(body: Node2D) -> void:
	can_useful_attack = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	can_useful_attack = false
