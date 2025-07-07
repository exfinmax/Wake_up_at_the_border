class_name PlayerState
extends Node

signal state_change(state:Player.State)

var player : Player
var animation : AnimationPlayer
var detect_area : Area2D
var defend_area : Area2D

func setup(context_player: Player, context_animation: AnimationPlayer, context_detect_area: Area2D, context_defend_area: Area2D) -> void:
	player = context_player
	animation = context_animation
	detect_area = context_detect_area
	defend_area = context_defend_area

func transfrom_state(state: Player.State) -> void:
	state_change.emit(state)
