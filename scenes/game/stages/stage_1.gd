extends BaseStage



func _ready() -> void:
	MusicPlayer.play_bgm(preload("res://assets/Mp3/time_for_adventure.mp3"))
	if ResourceLoader.exists("user://savegame.tres"):
		get_tree().call_group("Can_Save", "on_before_load_game")
	
