# NPC脚本，负责NPC的对话、任务、交互等
class_name Npc
extends Node2D



@export var npc_id: String
@export var npc_name: String
@export var current_dia_state: String

@export var sprite: Texture2D
@export var custom_scale: Vector2
@export var dia_texture: Texture2D

@export var dialog_resource: Dialog

@export var quests: Array[Quest] = []
var quest_manager: Node2D = null

@onready var dialog_manager: Node2D = $DialogManager
@onready var npc_sprite: Sprite2D = $Body/NpcSprite
@onready var body: Node2D = %Body

var current_branch_index = 0



func _ready() -> void:
	add_to_group("NPC")
	initialize()
	print("NPC Ready, Quests loaded: ", quests.size())
	
	
func start_dialogue() -> void:
	var npc_dialogs = dialog_resource.get_npc_dialog(npc_id)
	if npc_dialogs.is_empty():
		return
	dialog_manager.show_dialog(self)

func get_current_dialog():
	var dialogs = dialog_resource.get_npc_dialog(npc_id)
	if current_branch_index < dialogs.size():
		for dialog in dialogs[current_branch_index]["dialogs"]:
			if dialog["state"] == current_dia_state:
				return dialog
	return null

func set_dialog_branch(branch_index):
	current_branch_index = branch_index
	current_dia_state = "start"
	
	
func set_dialog_state(state):
	current_dia_state = state

func offer_quest(quest_id: String):
	print("Attempting to offer quest: ", quest_id)
	
	for quest in quests:
		if quest.quest_id == quest_id && quest.state == "not_started":
			quest.state = "in_progress"
			quest_manager.add_quest(quest)
			return
			
	print("Quest not found or started already")

func get_quest_dialog() -> Dictionary:
	if quest_manager == null:
		quest_manager = Global.player.quest_manager
	var active_quests :Array = quest_manager.get_active_quests()
	for quest in active_quests:
		for objective in quest.objectives:
			if objective.target_id == npc_id && objective.target_type == "talk_to" && not objective.is_completed:
				if current_dia_state == "start" || current_dia_state.begins_with("dia"):
					return{"text": objective.objective_dialog, "options": {}}
	
	return {"text": "", "options": {}}

func switch_state(_state: BaseNpc.State, _data:NpcData = NpcData.new()) -> void:
	pass

func on_save_game(saved_data:Array[SavedData]):
	var my_data = NpcResource.new()
	my_data.scene_path = scene_file_path
	my_data.position = global_position
	my_data.npc_id = npc_id
	my_data.npc_name = npc_name
	my_data.current_dia_state = current_dia_state
	my_data.sprite = sprite
	my_data.custom_scale = custom_scale
	my_data.dia_texture = dia_texture
	my_data.dialog_resource = dialog_resource
	my_data.quests = quests
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(save_data:SavedData):
	var saved_data:NpcResource = save_data
	global_position = saved_data.position
	npc_id = saved_data.npc_id
	npc_name = saved_data.npc_name
	current_dia_state = saved_data.current_dia_state
	sprite = saved_data.sprite
	custom_scale = saved_data.custom_scale
	dia_texture = saved_data.dia_texture
	dialog_resource = saved_data.dialog_resource
	quests = saved_data.quests
	initialize()
	

func initialize() -> void:
	npc_sprite.texture = sprite
	body.scale = custom_scale
	dialog_resource.load_from_json("res://Resource/dialogue/dialogue_data.json")
	dialog_manager.npc = self
	dialog_manager.set_texture(dia_texture)
	if current_dia_state.begins_with("dia"):
		dialog_manager.set_button_visible()
	quest_manager = Global.player.quest_manager
