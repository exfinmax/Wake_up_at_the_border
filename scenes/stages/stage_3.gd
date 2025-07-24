extends Node2D

@onready var chaser = $Chaser
@onready var player_start = $PlayerStart

var switches_activated = 0
var can_exit = false

#func _ready():
	#for s in switches:
		#s.get_node("Area2D").connect("body_entered", Callable(self, "on_switch_activated").bind(s))
	#chaser.connect("player_caught", Callable(self, "on_player_caught"))

func on_switch_activated(body, s):
	if body.is_in_group("Player") and not s.get_meta("activated"):
		s.set_meta("activated", true)
		s.modulate = Color(0,1,0)
		switches_activated += 1
		#if switches_activated == switches.size():
			#for gate in gates:
				#gate.visible = false
			#can_exit = true

func on_player_caught():
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.global_position = player_start.global_position
	chaser.reset()
	switches_activated = 0
	#for s in switches:
		#s.set_meta("activated", false)
		#s.modulate = Color(1,1,1) 
