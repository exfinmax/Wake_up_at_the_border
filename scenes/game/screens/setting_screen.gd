extends Screen
class_name Setting

@onready var button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Button
@onready var end_1: Button = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer2/end1
@onready var end_2: Button = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer2/end2
@onready var end_3: Button = $MarginContainer/VBoxContainer/GridContainer/HBoxContainer2/end3


	

func _ready() -> void:

	button.pressed.connect(on_button_pressed.bind())
	MusicPlayer.setup_ui_sounds(self)


func on_button_pressed() -> void:
	GameEvents.set_end.emit()
	transition_state(TheGame.ScreenType.MAIN_MENU)

	
