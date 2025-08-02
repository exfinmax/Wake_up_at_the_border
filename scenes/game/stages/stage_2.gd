extends BaseStage

@onready var npc: Npc = $Npc
@onready var npc_2: Npc = $Npc2
@onready var node_2d: Node2D = $Node2D
var quest_item: Area2D 
var snail: Snail

var death_enemy:int = 0

func _ready() -> void:
	super._ready()





func on_enemy_death(enemy: BaseEnemy) -> void:
	death_enemy += 1
	if death_enemy == 6:
		for child in get_children():
			if child.is_in_group("Item"):
				quest_item = child
				break
		for child in get_children():
			if child is Snail:
				snail = child
				break
		snail.global_position = node_2d.global_position
	if enemy is Snail:
		quest_item.global_position = enemy.global_position
		quest_item.scale = enemy.body.scale
		npc_2.dialogue_start = "stage2_2"
		npc_2.is_once = true
		npc.dialogue_start = "stage2_3"
	await enemy.animation_player.animation_finished
	enemy.queue_free()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if death_enemy == 7:
		npc.action()
		GlobalSave.save_game()
