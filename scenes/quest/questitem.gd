# 任务物品脚本，负责任务相关物品的逻辑




@tool
extends Area2D


@export var item_id: String = ""
@export var item_quantity: int 
@export var item_icon : Texture2D
@export var custom_scale: Vector2 = Vector2(1, 1)

@onready var item: Sprite2D = $Item

func _ready() -> void:
	scale = custom_scale
	if not Engine.is_editor_hint():
		item.texture = item_icon

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		item.texture = item_icon

func on_save_game(save_data:Array[SavedData]) -> void:
	var my_data = ItemResource.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.item_icon = item_icon
	my_data.item_quantity = item_quantity
	my_data.item_id = item_id
	my_data.custom_scale = custom_scale
	save_data.append(my_data)

func on_before_load_game() -> void:
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData) -> void:
	var my_data:ItemResource = saved_data
	global_position = my_data.position
	item_icon = my_data.item_icon
	item_quantity = my_data.item_quantity
	item_id = my_data.item_id
	item_icon = my_data.item_icon
	custom_scale = my_data.custom_scale
	_initialize()

func _initialize():
	scale = custom_scale
	item.texture = item_icon
