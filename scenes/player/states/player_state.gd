# 玩家状态基类
class_name PlayerState
extends Node

signal state_change(state:Player.State, data: PlayerData)

# 关键引用
var player : Player
var player_data : PlayerData
var animation : AnimationPlayer
var interact_area : Area2D
var quest_conponent: Node2D
var quest_manager: Node2D
var health_component: Node2D
var attack_component: Node2D

# 初始化状态
func setup(context_player: Player, context_animation: AnimationPlayer, context_interact_area: Area2D, context_quest_conponent: Node2D, context_quest_manager: Node2D, context_health_component: Node2D, context_attack_component: Node2D, context_data: PlayerData) -> void:
	player = context_player
	animation = context_animation
	interact_area = context_interact_area
	quest_conponent = context_quest_conponent
	quest_manager = context_quest_manager
	health_component = context_health_component
	attack_component = context_attack_component
	player_data = context_data
	
	
# 切换状态信号
func transfrom_state(state: Player.State, data: PlayerData = PlayerData.new()) -> void:
	state_change.emit(state, data)
