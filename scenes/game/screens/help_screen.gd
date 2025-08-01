class_name HelpScreen
extends Screen

func _ready() -> void:
	MusicPlayer.setup_ui_sounds(self)


func _on_button_pressed() -> void:
	transition_state(TheGame.ScreenType.MAIN_MENU)
