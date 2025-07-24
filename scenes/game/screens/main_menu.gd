# 主菜单脚本，负责主菜单界面的逻辑
class_name Main_Menu
extends Screen

@onready var start: Button = %Start
@onready var load_game: Button = %Load
@onready var option: Button = %Set
@onready var exit: Button = %Exit


func _ready() -> void:
	start.pressed.connect(on_start_pressed.bind())
	load_game.pressed.connect(on_load_pressed.bind())
	option.pressed.connect(on_option_pressed.bind())
	exit.pressed.connect(on_exit_pressed.bind())
	MusicPlayer.setup_ui_sounds(self)
	MusicPlayer.play_bgm(preload("res://assets/Mp3/21_loop.mp3"))

func on_start_pressed() -> void:
	transition_state(TheGame.ScreenType.IN_GAME)

func on_load_pressed() -> void:
	GlobalSave.load_game()

func on_option_pressed() -> void:
	transition_state(TheGame.ScreenType.SETTING, ScreenData.buide().last_screen(self.name))

func on_exit_pressed() -> void:
	get_tree().quit()
