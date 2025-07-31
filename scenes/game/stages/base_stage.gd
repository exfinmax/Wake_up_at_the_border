class_name BaseStage
extends Node

@export var stream: AudioStream
var current_timer:Timer

func _ready() -> void:
	Global.current_stage = name
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(on_timeout.bind())
	add_child(timer)
	current_timer = timer
	timer.start()
	
	if stream:
		MusicPlayer.play_bgm(stream)

	
func on_timeout() -> void:
	GameEvents.stage_ready.emit()
	if stream:
		MusicPlayer.play_bgm(stream)
	current_timer.queue_free()
	
func _exit_tree() -> void:
	MusicPlayer.bgm_player.stream = null
