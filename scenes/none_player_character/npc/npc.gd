# NPC脚本，负责NPC的对话、任务、交互等
class_name Npc
extends CharacterBody2D



const Balloon = preload("res://dialogue/balloon.tscn")

@export var npc_id:String
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var sprite_frames: SpriteFrames
@export var custom_scale: Vector2
@export var dia_texture: Texture2D
@export var is_once:bool

@export var quests: Array[Quest] = []
var quest_manager: Node2D = null


@onready var npc_animated_sprite: AnimatedSprite2D = $Body/NpcAnimatedSprite
@onready var body: Node2D = %Body

var current_branch_index = 0



func _ready() -> void:
	add_to_group("NPC")
	initialize()
	GameEvents.push_quest.connect(offer_quest.bind())
	GameEvents.dialog_end.connect(on_dialogue_end.bind())
	print("NPC Ready, Quests loaded: ", quests.size())
	
	

func action() -> void:
	var balloon: Node = Balloon.instantiate()
	Global.player.can_move = false
	if get_tree().current_scene != null:
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialogue_resource, dialogue_start, [dia_texture])
	


func offer_quest(cur_npc_id: String,quest_id: String):
	print("Attempting to offer quest: ", quest_id)
	if cur_npc_id != npc_id:
		return
	for quest in quests:
		if quest.quest_id == quest_id && quest.state == "not_started":
			quest.state = "in_progress"
			quest_manager = Global.player.quest_manager
			quest_manager.add_quest(quest)
			print("Quest already")
			return
			
	print("Quest not found or started already")

func _process(delta: float) -> void:
	set_heading()
	velocity += get_gravity() * delta
	if is_on_floor():
		velocity = Vector2.ZERO

func set_heading() -> void:
	if Global.player != null:
		var direction := (Global.player.global_position - global_position).normalized()
		if direction.x > 0:
			body.scale.x = custom_scale.x
		else:
			body.scale.x = -custom_scale.x


func on_dialogue_end(cur_id: String) -> void:
	if cur_id == npc_id && is_once:
		queue_free()

func initialize() -> void:
	npc_animated_sprite.sprite_frames = sprite_frames
	if sprite_frames != null:
		npc_animated_sprite.play("default")
	body.scale = custom_scale
	quest_manager = Global.player.quest_manager
