class_name PlayerStateDash
extends PlayerState

var current_atk:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.can_be_hurt = false
	player.current_energy -= 2
	player.can_recover_energy = false
	animation.play("dash")
	player.velocity.x = player.run_speed * 3 * player.heading
	current_atk = attack_component.atk
	attack_component.atk = 20
	

func _physics_process(_delta: float) -> void:
	set_physics_process(false)
	await get_tree().create_timer(0.05).timeout
	attack_component.check_attack()
	set_physics_process(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	set_process(false)
	await get_tree().create_timer(0.3).timeout
	player.velocity = Vector2.ZERO
	await animation.animation_finished
	
	transfrom_state(Player.State.MOVE)

func _exit_tree() -> void:
	player.can_be_hurt = true
	player.can_recover_energy = true
	attack_component.atk = current_atk
