class_name PlayerStateFactory

var states :Dictionary= {}

func _init() -> void:
	states = {
		Player.State.ATTACK : PlayerStateAttack,
		Player.State.MOVE : PlayerStateMove,
		Player.State.AIR : PlayerStateAir,
		
	}

func change_state(state:Player.State ) -> PlayerState:
	assert(states.has(state))
	return states.get(state).new()
