# 任务组件，负责任务目标检测与交互



extends Node2D



@onready var title: Label = %Title
@onready var objectives: VBoxContainer = %Objectives
@onready var quest_manager: Node2D = %QuestManager
@onready var quest_tracker: ColorRect = %QuestTracker


var selected_quest: Quest = null


func _ready() -> void:
	
	quest_manager.quest_updated.connect(_on_quest_update)
	quest_manager.objective_updated.connect(_on_objective_updated)


func is_item_needed(item_id: String) -> bool:
	if selected_quest != null:
		for objective in selected_quest.objectives:
			if objective.target_id == item_id && objective.target_type == "collection" && not objective.is_completed:
				return true
	return false

func check_quest_objectives(target_id: String, target_type: String, quantity: int = 1):
	if selected_quest == null:
		return
	
	var objective_updated = false
	for objective in selected_quest.objectives:
		if objective.target_id == target_id && objective.target_type == target_type && not objective.is_completed:
			print("Completeing objective for quest: ", selected_quest.quest_name)
			selected_quest.complete_objective(objective.id, quantity)
			objective_updated = true
			break
	
	
	if objective_updated:
		if selected_quest.is_completed():
			handle_quest_completed(selected_quest)
		
		update_quest_tracker(selected_quest)
		
func handle_quest_completed(quest: Quest):
	for reward in quest.rewards:
		if reward.reward_type == "energy":
			Global.player.max_energy += reward.reward_amount
			Global.player.energy_progress_bar.max_value = Global.player.max_energy
		elif reward.reward_type == "energy_speed":
			Global.player.energy_recover_speed += reward.reward_amount
		elif reward.reward_type == "hp":
			Global.player.max_hp += reward.reward_amount
		elif reward.reward_type == "atk":
			Global.player.attack_component.atk += reward.reward_amount
		elif reward.reward_type == "skill":
			Global.player_skill[reward.reward_amount] = true
			Global.player.reload_skill()
		elif reward.reward_type == "unlock_hp":
			Global.player.health_component.can_recover_hp = true
	update_quest_tracker(quest)
	quest_manager.update_quest(quest.quest_id, "completed")
	GameEvents.quest_complete.emit()



func update_quest_tracker(quest: Quest):
	if quest:
		quest_tracker.visible = true
		title.text = quest.quest_name
		
		for child in objectives.get_children():
			objectives.remove_child(child)
		
		for objective in quest.objectives:
			var label = Label.new()
			label.add_theme_font_size_override("font_size", 20)
			label.custom_minimum_size.x = 300.0
			label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
			label.text = objective.description
			
			if objective.is_completed:
				label.add_theme_color_override("font_color", Color(0, 1, 0))
			else:
				label.add_theme_color_override("font_color", Color(1, 0, 0))
			
			objectives.add_child(label)
		GameEvents.get_quest.emit()
	else:
		quest_tracker.visible = false

func _on_quest_update(quest_id: String):
	var quest = quest_manager.get_quest(quest_id)
	if quest == selected_quest:
		update_quest_tracker(quest)
	selected_quest = null

func _on_objective_updated(quest_id: String, _objective_id: String):
	if selected_quest && selected_quest.quest_id == quest_id:
		update_quest_tracker(selected_quest)
	selected_quest = null
