class_name BaseStage
extends Node


func _ready() -> void:
	add_to_group("Can_Save")

func on_save_game(saved_data:Array[SavedData]):
	
	var my_data = SavedData.new()
	my_data.scene_path = scene_file_path
	
	saved_data.append(my_data)
