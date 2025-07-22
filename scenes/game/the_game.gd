# 游戏主流程脚本，负责关卡切换、主界面等




class_name TheGame
extends Node

enum ScreenType {
	IN_GAME,
	STAGE_SELECTION,
	SETTING,
	MAIN_MENU,
}

var current_screen : Screen = null
var screen_factory := ScreenFactory.new()

func _init() -> void:
	switch_screen(ScreenType.IN_GAME)


func switch_screen(screen: ScreenType,data:ScreenData = ScreenData.new()) -> void:
	if current_screen != null:
		current_screen.queue_free()
	current_screen = screen_factory.get_fresh_state(screen)
	current_screen.set_up(self, data)
	current_screen.state_transition_requested.connect(switch_screen.bind())
	call_deferred("add_child", current_screen)
