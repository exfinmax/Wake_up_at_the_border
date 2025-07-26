# 玩家状态工厂，负责切换不同状态
class_name PlayerStateFactory

var states :Dictionary= {}

func _init() -> void:
	# 注册所有状态
	states = {
		Player.State.ATTACK : PlayerStateAttack,
		Player.State.MOVE : PlayerStateMove,
		Player.State.AIR : PlayerStateAir,
		Player.State.DEFEND : PlayerStateDefend,
		Player.State.HURT : PlayerStateHurt,
		Player.State.AIR_KICK : PlayerStateAirKick,
		Player.State.AIR_ATK : PlayerStateAirAtk
	}

# 切换状态，返回新状态实例
func change_state(state:Player.State ) -> PlayerState:
	assert(states.has(state))
	return states.get(state).new()
