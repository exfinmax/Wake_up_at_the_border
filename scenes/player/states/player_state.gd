class_name PlayerState
extends Node

signal state_change(state:Player.State, data: PlayerData)

var player : Player
var player_data : PlayerData
var animation : AnimationPlayer
var detect_area : Area2D
var defend_area : Area2D
var quest_conponent: Node2D
var quest_manager: Node2D

func setup(context_player: Player, context_animation: AnimationPlayer, context_detect_area: Area2D, context_defend_area: Area2D, context_quest_conponent: Node2D, context_quest_manager: Node2D, context_data: PlayerData) -> void:
	player = context_player
	animation = context_animation
	detect_area = context_detect_area
	defend_area = context_defend_area
	quest_conponent = context_quest_conponent
	quest_manager = context_quest_manager
	player_data = context_data

func transfrom_state(state: Player.State, data: PlayerData = PlayerData.new()) -> void:
	state_change.emit(state, data)
