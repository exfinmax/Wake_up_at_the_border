extends Node2D

@onready var boss = $Boss
@onready var dialog_manager = $DialogManager
@onready var endings = $Endings
var boss_defeated = false

func _ready():
	boss.connect("defeated", Callable(self, "on_boss_defeated"))
	dialog_manager.connect("choice_made", Callable(self, "on_choice_made"))

func on_boss_defeated():
	boss_defeated = true
	dialog_manager.start_ending_dialog()

func on_choice_made(choice):
	endings.show_ending(choice) 
