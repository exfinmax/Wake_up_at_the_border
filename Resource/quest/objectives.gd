class_name Objectives
extends Resource

@export var id: String
@export var description: String

@export var target_id: String
@export var target_type: String

@export var objective_dialog: String = ""

@export var required_quantity: int = 0
@export var collected_quantity: int = 0

@export var is_completed: bool = false
