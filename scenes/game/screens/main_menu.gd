# 主菜单脚本，负责主菜单界面的逻辑
class_name Main_Menu
extends Screen

@onready var start: Button = %Start
@onready var load_game: Button = %Load
@onready var option: Button = %Set
@onready var exit: Button = %Exit
@onready var v: VBoxContainer = $Control/V


func _ready() -> void:
	Global.current_screen = self
	start.pressed.connect(on_start_pressed.bind())
	load_game.pressed.connect(on_load_pressed.bind())
	option.pressed.connect(on_option_pressed.bind())
	exit.pressed.connect(on_exit_pressed.bind())
	MusicPlayer.setup_ui_sounds(self)
	MusicPlayer.play_bgm(preload("res://assets/Mp3/21_loop.mp3"))
	if ResourceLoader.exists("user://savegame.tres"):
		load_game.disabled = false

func on_start_pressed() -> void:
	var file_path = "user://savegame.tres"
	var dir = DirAccess.open("user://")
	if dir.file_exists(file_path):
		dir.remove(file_path)
		print("已删除")
	transition_state(TheGame.ScreenType.IN_GAME)
	v.visible = false

func on_load_pressed() -> void:
	GlobalSave.load_game()
	queue_free()
	

func on_option_pressed() -> void:
	transition_state(TheGame.ScreenType.SETTING)
	v.visible = false
	

func on_exit_pressed() -> void:
	get_tree().quit()
	v.visible = false
	
