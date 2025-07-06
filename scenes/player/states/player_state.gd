class_name PlayerState
extends Node

signal state_change(state:Player.State)

var player : Player
var animation : AnimationPlayer
var attack_area : Area2D

func setup(context_player: Player, context_animation: AnimationPlayer, context_attack_area: Area2D) -> void:
	player = context_player
	animation = context_animation
	attack_area = context_attack_area
	

func transfrom_state(state: Player.State) -> void:
	state_change.emit(state)
