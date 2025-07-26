class_name NpcResource
extends SavedData

@export var npc_id: String
@export var npc_name: String
@export var current_dia_state: String

@export var sprite: Texture2D
@export var custom_scale: Vector2
@export var dia_texture: Texture2D

@export var dialog_resource: Dialog

@export var quests: Array[Quest] = []
