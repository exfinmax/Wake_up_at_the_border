extends Screen
class_name Setting

@onready var button: Button = $MarginContainer/VBoxContainer/Button

func _ready() -> void:
	button.pressed.connect(on_button_pressed.bind())


func on_button_pressed() -> void:
	if screen_data.latest_screen == "MainMenu":
		transition_state(TheGame.ScreenType.MAIN_MENU)
	else:
		transition_state(TheGame.ScreenType.IN_GAME)
	


	
