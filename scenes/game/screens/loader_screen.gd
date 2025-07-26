class_name LoaderScreen
extends Node

const Shader_Patterns:String = "res://shader_patterns/"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

var _png_cache := {}
var current_scene: String = ""
var is_lode_down: bool = false

func _enter_tree() -> void:
	_preload_pngs()

func set_current_scene(scene: String) -> void:
	current_scene = scene

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



func rand_shader_fade(number: int = -1) -> bool:
	animation_player.play("ShaderFade")
	await animation_player.animation_finished
	if number < 0:
		number = randi_range(0,8)
	if number == 8:
		color_rect.set_instance_shader_parameter("fade", true)
	else:
		color_rect.material.set_shader_parameter("dissolve_texture", _png_cache.get(str(number)))
	await is_lode_down
	animation_player.play_backwards("ShaderFade")
	color_rect.set_instance_shader_parameter("fade", false)
	is_lode_down = false
	return true
