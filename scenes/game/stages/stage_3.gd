extends BaseStage

const bossGolem := preload("res://scenes/none_player_character/Boss/boss_golme.tscn")
const Music := preload("res://assets/Mp3/Dreamer's Domain.mp3")

var quest_item: Area2D
var cur_enemy:int

@onready var area_2d: Area2D = $Area2D
@onready var spawn_point: Node2D = $SpawnPoint
@onready var hidden_2: TileMapLayer = $TileMapLayer/hidden2
@onready var npc_2: Npc = $Npc2
@onready var npc: Npc = $Npc
@onready var area_2d_2: Area2D = $Area2D2
@onready var npc_3: Npc = $Npc3


func _ready() -> void:
	super._ready()
	GameEvents.boss_death.connect(on_Boss_death,CONNECT_ONE_SHOT)

func on_enemy_death(enemy: BaseEnemy) -> void:
	for i in get_children():
		if i is BaseEnemy:
			cur_enemy += 1
			continue
	for child in get_children():
		if child.is_in_group("Item"):
			quest_item = child
			break
	if cur_enemy == 1:
		quest_item.global_position = Global.player.global_position - Vector2(50, 10)
		npc_2.dialogue_start = "stage3_2"
		npc_2.is_once = true
		hidden_2.visible = false
		hidden_2.collision_enabled = false
	await enemy.animation_player.animation_finished
	enemy.queue_free()
	cur_enemy = 0
	




func _on_area_2d_body_entered(_body: Node2D) -> void:
	hidden_2.visible = true
	hidden_2.collision_enabled = true
	var boss := bossGolem.instantiate()
	boss.global_position = spawn_point.global_position
	call_deferred("add_child", boss)
	area_2d.queue_free()
	npc_3.action()
	await GameEvents.dialog_end
	npc_3.dialogue_start = "stage3_4"
	boss.animation.play("start")
	

func on_Boss_death() -> void:
	hidden_2.visible = false
	hidden_2.collision_enabled = false
	npc_3.action()
	hidden_2.queue_free()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	GlobalSave.save_game()
	area_2d_2.queue_free()
