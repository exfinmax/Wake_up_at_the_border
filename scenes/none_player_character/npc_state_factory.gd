class_name NpcStateFactory

var states :Dictionary= {}

func _init() -> void:
	states = {
		BaseNpc.State.ATTACK : NpcStateAttack,
		BaseNpc.State.MOVE : NpcStateMove,
		BaseNpc.State.AIR : NpcStateAir,
		BaseNpc.State.HURT : NpcStateHurt,
		BaseNpc.State.SPECIAL : NpcStateSpecial,
	}

func change_state(state:BaseNpc.State ) -> NpcState:
	assert(states.has(state))
	return states.get(state).new()
