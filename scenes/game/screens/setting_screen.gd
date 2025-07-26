extends Screen
class_name Setting

@onready var button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Button


	

func _ready() -> void:
	button.pressed.connect(on_button_pressed.bind())
	MusicPlayer.setup_ui_sounds(self)


func on_button_pressed() -> void:
	transition_state(TheGame.ScreenType.MAIN_MENU)

	
