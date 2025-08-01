class_name BaseStage
extends Node

@export var stream: AudioStream
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var next_stage: Area2D = $NextStage
var current_timer:Timer
var npcs: Array[Npc]

func _ready() -> void:
	GameEvents.enemy_death.connect(on_enemy_death.bind())
	next_stage.body_entered.connect(_on_next_stage_body_entered)
	Global.current_stage = name
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(on_timeout.bind())
	add_child(timer)
	current_timer = timer
	timer.start()
	for child in get_children():
		if child is Npc:
			npcs.append(child)
	if stream:
		MusicPlayer.play_bgm(stream)

func start_dialog() -> void:
	if npcs[0] != null:
		npcs[0].action()


func on_timeout() -> void:
	GameEvents.stage_ready.emit()
	if stream:
		MusicPlayer.play_bgm(stream)
	current_timer.queue_free()
	
func _exit_tree() -> void:
	MusicPlayer.bgm_player.stream = null
	GameEvents.is_load_game = false

func _on_next_stage_body_entered(_body: Node2D) -> void:
	get_parent().next_stage()

func on_enemy_death(enemy: BaseEnemy) -> void:
	enemy.queue_free()
