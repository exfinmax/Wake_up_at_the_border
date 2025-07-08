class_name NpcState
extends Node

signal state_change(state:BaseNpc.State, data: NpcData)

var npc :BaseNpc
var npc_data : NpcData
var animation: AnimationPlayer
var player_detect_area : Area2D
var floor_ray_cast : RayCast2D


func setup(context_npc: BaseNpc, context_animation: AnimationPlayer, context_player_detect_area: Area2D, context_floor_ray_cast: RayCast2D, context_data: NpcData) -> void:
	npc = context_npc
	animation = context_animation
	player_detect_area = context_player_detect_area
	floor_ray_cast = context_floor_ray_cast
	npc_data = context_data

func transfrom_state(state: BaseNpc.State, data: NpcData = NpcData.new()) -> void:
	state_change.emit(state, data)
