extends BaseStage

var npc: Npc = null
@onready var dia_player: Npc = $Player2
@onready var node_2d: Node2D = $Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _init() -> void:
	GameEvents.get_quest.connect(on_get_quest.bind(), CONNECT_ONE_SHOT)
	GameEvents.all_quest_completed.connect(on_all_quest_complete.bind(), CONNECT_ONE_SHOT)

func _ready() -> void:
	super._ready()
	for child in get_children():
		if child is Npc:
			npc = child
			break


func on_get_quest() -> void:
	if npc != null:
		npc.global_position = node_2d.global_position
		npc.body.scale.x = -npc.custom_scale.x
		npc.custom_scale.x = -npc.custom_scale.x

func on_all_quest_complete() -> void:
	var tween = create_tween()
	tween.tween_property(npc,"modulate:a", 0, 1.0)

func _on_next_stage_area_entered(area: Area2D) -> void:
	if npc != null:
		npc.visible = true
	await GameEvents.dialog_end
	get_parent().next_stage()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if dia_player != null:
		dia_player.start_dialogue()
		await GameEvents.dialog_end
		dia_player.queue_free()
