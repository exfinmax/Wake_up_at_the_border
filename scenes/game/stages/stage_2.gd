extends BaseStage

@onready var quest_item: Area2D = $QuestItem
@onready var snail: Snail = $Snail

var death_enemy:int = 0

func _ready() -> void:
	super._ready()




func on_enemy_death(enemy: BaseEnemy) -> void:
	death_enemy += 1
	if enemy is Snail:
		quest_item.global_position = enemy.global_position
		quest_item.scale = enemy.scale
	enemy.queue_free()
	if death_enemy == 6:
		snail.visible = true
