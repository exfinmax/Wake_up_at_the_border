# 屏幕基类，负责不同界面的切换和数据传递




class_name Screen
extends Node

signal state_transition_requested(new_state: TheGame.ScreenType, state_data:ScreenData)

var game : TheGame = null
var screen_data : ScreenData = null


func set_up(context_game: TheGame, context_data: ScreenData) -> void:
	game = context_game
	screen_data = context_data

func transition_state(new_state :TheGame.ScreenType , data: ScreenData = ScreenData.new()) -> void:
	state_transition_requested.emit(new_state, data)
