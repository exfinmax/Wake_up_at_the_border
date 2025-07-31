# 屏幕工厂，负责根据类型生成不同的游戏界面




class_name ScreenFactory
extends Node

# 存储不同屏幕类型的预加载场景
var type : Dictionary

func _init() -> void:
	# 初始化屏幕类型字典，将屏幕类型与对应的预加载场景关联
	type = {
		TheGame.ScreenType.MAIN_MENU: preload("res://scenes/game/screens/main_menu.tscn"), 
		TheGame.ScreenType.IN_GAME: preload("res://scenes/game/screens/WorldScreen.tscn"),
		TheGame.ScreenType.SETTING: preload("res://scenes/game/screens/setting_screen.tscn"),
		TheGame.ScreenType.THE_END: preload("res://scenes/game/screens/TheEnd.tscn"),
		TheGame.ScreenType.HELP : preload("res://scenes/game/screens/HelpScreen.tscn"),
	}

# 根据屏幕类型获取一个新的屏幕实例
func get_fresh_state(state: TheGame.ScreenType) -> Screen:
	# 断言确保屏幕类型存在，如果不存在则抛出错误
	assert(type.has(state), "state doesn't exist!")
	# 从字典中获取对应屏幕类型的预加载场景，并实例化
	return type.get(state).instantiate()
