# 对话管理器，负责对话UI的显示、对话流程控制



extends Node2D


@onready var dialogue_ui: Control = $DialogueUI

var npc: Npc = null




func show_dialog(cur_npc, _text = "", _options = {}):
	check_and_advance_branch()
	var quest_dialog = cur_npc.get_quest_dialog()
	if quest_dialog["text"] != "":
		print("123")
		dialogue_ui.show_dialog(cur_npc.npc_name, quest_dialog["text"], quest_dialog["options"])
	
	else:
		var dialog = cur_npc.get_current_dialog()
		if dialog:
			dialogue_ui.show_dialog(cur_npc.npc_name, dialog["text"], dialog["options"])
	if cur_npc.npc_name.begins_with("player"):
		cur_npc.queue_free()
	
	
	
func hide_dialog():
	dialogue_ui.hide_dialog()
	
	

func handle_dialog_choice(option):
	var current_dialog = npc.get_current_dialog()
	if current_dialog == null:
		return
	var next_state:String
	if not option is String:
		next_state = current_dialog["options"].get(option.text, "start")
	else:
		next_state = current_dialog["options"].get(option, "start")
	npc.set_dialog_state(next_state)
	
	if next_state == "end":
		if all_quests_completed_for_branch(npc.current_branch_index):
			advance_to_next_branch()
		else:
			npc.set_dialog_state("exit")
			show_dialog(npc)
			npc.set_dialog_state("start")
	elif next_state == "exit":
		npc.set_dialog_state("start")
		hide_dialog()
	elif next_state == "give_quests":
		offer_quests(npc.dialog_resource.get_npc_dialog(npc.npc_id)[npc.current_branch_index]["branch_id"])
		show_dialog(npc)
	
	elif next_state.begins_with("dia"):
		dialogue_ui.can_show_button = false
		show_dialog(npc)
	
	else:
		show_dialog(npc)

func set_texture(texture: Texture2D) -> void:
	dialogue_ui.texture = texture 

func set_button_visible() -> void:
	dialogue_ui.can_show_button = false

func offer_quests(branch_id: String):
	for quest in npc.quests:
		if quest.unlock_id == branch_id && quest.state == "not_started":
			npc.offer_quest(quest.quest_id)

func offer_remaining_quests():
	for quest in npc.quests:
		if quest.state == "not_started":
			npc.offer_quest(quest.quest_id)
	
func all_quests_completed_for_branch(branch_index):
	var branch_id = npc.dialog_resource.get_npc_dialog(npc.npc_id)[branch_index]["branch_id"]
	for quest in npc.quests:
		if quest.unlock_id == branch_id and quest.state != "completed":
			return false
	return true

func check_and_advance_branch():
	if all_quests_completed_for_branch(npc.current_branch_index) and npc.current_branch_index < npc.dialog_resource.get_npc_dialog(npc.npc_id).size() - 1:
		advance_to_next_branch()

func advance_to_next_branch():
	npc.set_dialog_branch(npc.current_branch_index + 1)
	npc.set_dialog_state("dia_1")
	show_dialog(npc)
