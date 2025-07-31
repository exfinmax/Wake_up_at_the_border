# 游戏主流程脚本，负责关卡切换、主界面等
class_name TheGame
extends Node



enum ScreenType {
	IN_GAME,
	MAIN_MENU,
	SETTING,
	THE_END,
	HELP,
}

var current_screen : Screen = null
var screen_factory := ScreenFactory.new()

@onready var loader_screen: LoaderScreen = $LoaderScreen



# 场景预加载缓存


func _ready() -> void:
	GlobalSave.load_set()
	Global.loader_screen = loader_screen
	switch_screen(ScreenType.SETTING)
	switch_screen(ScreenType.MAIN_MENU)

func switch_screen(screen: ScreenType,data:ScreenData = ScreenData.new()) -> void:
	loader_screen.rand_shader_fade()
	await loader_screen.animation_player.animation_finished
	if current_screen != null:
		current_screen.queue_free()
	current_screen = screen_factory.get_fresh_state(screen)
	current_screen.set_up(self, data)
	current_screen.state_transition_requested.connect(switch_screen.bind())
	call_deferred("add_child", current_screen)
	await get_tree().create_timer(0.5).timeout
	loader_screen.is_lode_down = true

	
	


	
