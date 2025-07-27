# 任务物品脚本，负责任务相关物品的逻辑




@tool
extends Area2D


@export var item_id: String = ""
@export var item_quantity: int 
@export var item_icon : Texture2D

@onready var item: Sprite2D = $Item

func _ready() -> void:
	if not Engine.is_editor_hint():
		item.texture = item_icon

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		item.texture = item_icon

func on_save_game(save_data:Array[SavedData]) -> void:
	var my_data = SavedData.new()
	my_data.scene_path = scene_file_path
	save_data.append(my_data)

func on_before_load_game() -> void:
	get_parent().remove_child(self)
	queue_free()
