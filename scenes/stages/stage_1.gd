extends Node2D

@onready var torch_pieces = $TorchPieces.get_children()
@onready var fog = $Fog
@onready var npc = $NPC
@onready var exit = $Exit
var collected = 0
var can_exit = false

func _ready():
    for piece in torch_pieces:
        piece.get_node("Area2D").connect("body_entered", Callable(self, "on_piece_collected").bind(piece))
    fog.visible = true
    exit.visible = false
    npc.connect("quest_accepted", Callable(self, "on_quest_accepted"))
    exit.connect("area_entered", Callable(self, "on_exit_entered"))

func on_piece_collected(body, piece):
    if body.is_in_group("Player"):
        piece.queue_free()
        collected += 1
        if collected == torch_pieces.size():
            fade_out_fog()
            exit.visible = true
            can_exit = true
            npc.emit_signal("quest_completed")

func fade_out_fog():
    var tween = create_tween()
    tween.tween_property(fog, "modulate:a", 0.0, 1.5)
    tween.tween_callback(Callable(self, "_on_fog_faded"))

func _on_fog_faded():
    fog.visible = false

func on_quest_accepted():
    pass

func on_exit_entered(body):
    if can_exit and body.is_in_group("Player"):
        get_tree().change_scene_to_file("res://scenes/stages/stage_2.tscn") 