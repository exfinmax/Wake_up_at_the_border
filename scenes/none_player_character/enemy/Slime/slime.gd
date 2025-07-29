class_name Slime
extends BaseNpc

enum SlimeType {Green, Purple}

const DIR :Dictionary = {
	SlimeType.Green : preload("res://assets/sprites/slime_green.png"),
	SlimeType.Purple : preload("res://assets/sprites/slime_purple.png"),
}

@onready var attack: Attack = %Attack
@onready var find_playerarea: Area2D = %FindPlayerarea
@onready var animation: AnimationPlayer = $AnimationPlayer


@onready var npc_sprite: Sprite2D = $Body/NpcSprite

func _ready() -> void:
	var self_type = randi_range(0,1) as SlimeType
	npc_sprite.texture = DIR.get(self_type)
	super._ready()

func initialize() -> void:
	animation_player = animation
	find_player_area = find_playerarea
	self.add_to_group("Enemy")


	
