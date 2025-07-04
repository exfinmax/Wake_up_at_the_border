class_name ScreenFactory
extends Node

var type : Dictionary

func _init() -> void:
	type = {
		TheGame.ScreenType.MAIN_MENU: preload("res://scenes/game/screens/main_menu.tscn"),
		TheGame.ScreenType.STAGE_SELECTION: preload("res://scenes/game/screens/main_menu.tscn"), 
		TheGame.ScreenType.IN_GAME: preload("res://scenes/game/screens/world_screen.tscn"),
		TheGame.ScreenType.SETTING: preload("res://scenes/game/screens/main_menu.tscn"),
	}

func get_fresh_state(state: TheGame.ScreenType) -> Screen:
	assert(type.has(state), "state doesn't exist!")
	return type.get(state).instantiate()
