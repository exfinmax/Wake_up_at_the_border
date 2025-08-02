extends Control


@onready var button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Button
@onready var button_2: Button = $MarginContainer/VBoxContainer/HBoxContainer/Button2


	

func _ready() -> void:
	button.pressed.connect(on_button_pressed.bind())
	button_2.pressed.connect(on_button_2_pressed.bind())
	MusicPlayer.setup_ui_sounds(self)


func on_button_pressed() -> void:
	get_tree().paused = false
	GameEvents.set_end.emit()
	visible = false

func on_button_2_pressed() -> void:
	get_tree().paused = false
	GameEvents.set_end.emit()
	visible = false
	get_parent().get_parent().transition_state(TheGame.ScreenType.MAIN_MENU)
