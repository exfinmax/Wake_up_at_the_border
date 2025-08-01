class_name NpcResource
extends SavedData


@export var npc_id: String
@export var dialogue_start: String

@export var sprite_frames: SpriteFrames
@export var custom_scale: Vector2
@export var dia_texture: Texture2D

@export var dialog_resource: DialogueResource

@export var quests: Array[Quest] = []
