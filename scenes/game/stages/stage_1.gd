extends BaseStage



var dia_number: int

func _init() -> void:
	GameEvents.all_quest_completed.connect(on_all_quest_complete.bind())
	GameEvents.dialog_end.connect(on_dialog_end.bind())
	

func _ready() -> void:
	super._ready()
	if npcs[3] != null:
		npcs[3].visible = false
	next_stage.visible = false

func change_visible() -> void:
	next_stage.visible = true



func on_dialog_end(id:String) -> void:
	if id == "4":
		next_stage.visible = true


func on_all_quest_complete() -> void:
	for child in get_children():
		if child is Npc:
			npcs.append(child)
	npcs[2].action()
	npcs[3].visible = true


	
