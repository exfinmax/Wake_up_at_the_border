extends Node

var set_dic: Dictionary = {}

signal is_load_over

func _init() -> void:
	GameEvents.stage_end.connect(save_game)
	GameEvents.get_quest.connect(save_game)
	GameEvents.quest_complete.connect(save_game)
	GameEvents.player_death.connect(load_game)
	GameEvents.set_end.connect(save_set)

	


func save_set() -> void:
	set_dic = Global.current_setting
	var file = FileAccess.open("user://saveset.data",FileAccess.WRITE)
	file.store_var(set_dic)
	file.close()

func save_game():
	var save_game:SaveGame = SaveGame.new()
	
	save_game.current_stage = Global.current_stage
	
	var saved_data:Array[SavedData] = []
	get_tree().call_group("Can_Save", "on_save_game", saved_data)
	save_game.saved_data = saved_data
	
	ResourceSaver.save(save_game, "user://savegame.tres")



func load_set() -> void:
	var file = FileAccess.open("user://saveset.data",FileAccess.READ)
	if file != null:
		Global.current_setting = file.get_var()
	
	


func load_game() -> void:
	var saved_game:SaveGame = load("user://savegame.tres")
	
	Global.current_stage = saved_game.current_stage
	Global.current_screen.transition_state(TheGame.ScreenType.IN_GAME)
	await GameEvents.stage_changed
	get_tree().call_group("Can_Save", "on_before_load_game")
	
	for item in saved_game.saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		Global.current_scene.add_child(restored_node)
		
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
	

func load_stage() -> void:
	var saved_game:SaveGame = load("user://savegame.tres")
	get_tree().call_group("Can_Save", "on_before_load_game")
	
	for item in saved_game.saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		Global.current_scene.add_child(restored_node)
		
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
	is_load_over.emit()
	
