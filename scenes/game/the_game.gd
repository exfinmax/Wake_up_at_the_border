# 游戏主流程脚本，负责关卡切换、主界面等
class_name TheGame
extends Node

const Shader_Patterns:String = "res://shader_patterns/"

enum ScreenType {
	IN_GAME,
	SETTING,
	MAIN_MENU,
	THE_END,
}

var current_screen : Screen = null
var screen_factory := ScreenFactory.new()


@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# 场景预加载缓存
var _png_cache := {}

func _ready() -> void:
	_preload_pngs()
	switch_screen(ScreenType.MAIN_MENU)

func _preload_pngs() -> void:
	var dir = DirAccess.open(Shader_Patterns)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png"):
				var stage_name = file_name.get_basename()
				var stage_path = Shader_Patterns + file_name
				_png_cache[stage_name] = load(stage_path)
			file_name = dir.get_next()
		dir.list_dir_end()

func switch_screen(screen: ScreenType,data:ScreenData = ScreenData.new()) -> void:
	if current_screen != null:
		current_screen.queue_free()
	current_screen = screen_factory.get_fresh_state(screen)
	current_screen.set_up(self, data)
	current_screen.state_transition_requested.connect(switch_screen.bind())
	rand_shader_fade()
	call_deferred("add_child", current_screen)

func rand_shader_fade(number: int = -1) -> void:
	animation_player.play("ShaderFade")
	await animation_player.animation_finished
	if number < 0:
		number = randi_range(0,7)
	if number == 8:
		color_rect.set_instance_shader_parameter("fade", true)
	else:
		color_rect.material.set_shader_parameter("dissolve_texture", _png_cache.get(str(number)))
	animation_player.play_backwards("ShaderFade")
	await animation_player.animation_finished
	color_rect.set_instance_shader_parameter("fade", false)
