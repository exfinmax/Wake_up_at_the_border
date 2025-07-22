extends Node2D

@export var is_dream_state: bool = true
@onready var dream_platforms = $DreamPlatforms
@onready var real_platforms = $RealPlatforms
@onready var enemy_group = $Enemies
@onready var switch_button = $SwitchButton
@onready var key = $DreamPlatforms/Key
@onready var door = $RealPlatforms/Door
var has_key = false

func _ready():
	update_state()
	switch_button.connect("body_entered", Callable(self, "on_switch"))
	key.get_node("Area2D").connect("body_entered", Callable(self, "on_key_collected"))
	door.get_node("Area2D").connect("body_entered", Callable(self, "on_door_entered"))

func on_switch(body):
	if body.is_in_group("Player"):
		is_dream_state = !is_dream_state
		update_state()

func update_state():
	dream_platforms.visible = is_dream_state
	real_platforms.visible = !is_dream_state
	for enemy in enemy_group.get_children():
		enemy.set_process(is_dream_state)

func on_key_collected(body):
	if body.is_in_group("Player"):
		has_key = true
		key.queue_free()

func on_door_entered(body):
	if has_key and body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://scenes/stages/stage_3.tscn") 
