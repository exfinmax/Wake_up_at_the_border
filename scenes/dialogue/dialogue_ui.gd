# 对话UI脚本，负责对话界面的显示与交互



extends Control

signal text_show_off

@export var text_show_time: float

@onready var panel: Panel = $CanvasLayer/Panel
@onready var dia_speaker: Label = $CanvasLayer/Panel/DialogBox/Speaker
@onready var dia_text: Label = %Text
@onready var dia_options: HBoxContainer = %Options
@onready var dia_speaker_icon: TextureRect = $CanvasLayer/Panel/DialogBox/HBoxContainer/SpeakerIcon

var can_show_button: bool = true
var texture: Texture2D
var total_delta :float


func _ready() -> void:
	hide_dialog()

func _process(delta: float) -> void:
	if dia_text.visible_characters >= 0:
		total_delta += delta
		if Input.is_action_just_pressed("ui_cancel"):
			dia_text.visible_characters = dia_text.text.length()
			emit_signal("text_show_off")
			set_process(false)
		
		if total_delta > text_show_time:
			dia_text.visible_characters += 1
			total_delta = 0.0
			if dia_text.visible_characters == dia_text.text.length():
				emit_signal("text_show_off")
				set_process(false)

func show_dialog(speaker, text: String, options: Dictionary):
	panel.visible = true
	
	dia_speaker.text = speaker
	for option in dia_options.get_children():
		dia_options.remove_child(option)
	dia_text.visible_characters = 0
	dia_text.text = text
	if texture:
		dia_speaker_icon.texture = texture  
	else:
		dia_speaker_icon.visible = false
	set_process(true)
	
	await text_show_off
	
	for option in dia_options.get_children():
		dia_options.remove_child(option)
	
	if not options.is_empty():
		for option in options.keys():
			var button = Button.new()
			button.text = option
			button.add_theme_color_override("font_size", 20)
			button.pressed.connect(_on_option_selected.bind(button))
			button.visible = true if can_show_button else false
			dia_options.add_child(button)
	
	else:
		while true:
			if Input.is_action_just_pressed("interact"):
				hide_dialog()
				break
			await get_tree().process_frame
	
	while not can_show_button:
		if Input.is_action_just_pressed("interact"):
			can_show_button = true
			_on_option_selected("next")
		await get_tree().process_frame


func _on_option_selected(option):
	get_parent().handle_dialog_choice(option)


func hide_dialog():
	panel.visible = false
	GameEvents.dialog_end.emit()


func _on_close_button_pressed() -> void:
	hide_dialog()
