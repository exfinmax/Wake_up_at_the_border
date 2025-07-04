class_name PlayerState
extends Node

signal state_change(state:Player.State)

var player : Player
var animation : AnimationPlayer
var floor_ray_cast : RayCast2D

func setup(context_player: Player, context_animation: AnimationPlayer, context_ray_cast: RayCast2D) -> void:
	player = context_player
	animation = context_animation
	floor_ray_cast = context_ray_cast

func transfrom_state(state: Player.State) -> void:
	state_change.emit(state)
