extends BaseStage

const bossGolem := preload("res://scenes/none_player_character/Boss/boss_golme.tscn")
const Music := preload("res://assets/Mp3/Dreamer's Domain.mp3")

@onready var area_2d: Area2D = $Area2D
@onready var spawn_point: Node2D = $SpawnPoint



func _on_area_2d_body_entered(_body: Node2D) -> void:
	var boss := bossGolem.instantiate()
	boss.global_position = spawn_point.global_position
	call_deferred("add_child", boss)
	area_2d.queue_free()
	
