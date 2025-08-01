# NPC状态工厂，负责切换NPC的不同状态




class_name NpcStateFactory

# 存储所有NPC状态的词典
# 键：BaseNpc.State枚举值
# 值：对应状态的类
var states :Dictionary= {}

# 初始化函数
# 在NPC状态工厂创建时调用
# 初始化所有可能的状态，并存储在states字典中
func _init() -> void:
	states = {
		BaseEnemy.State.ATTACK : NpcStateAttack,
		BaseEnemy.State.MOVE : NpcStateMove,
		BaseEnemy.State.AIR : NpcStateAir,
		BaseEnemy.State.HURT : NpcStateHurt,
		BaseEnemy.State.SPECIAL : NpcStateSpecial,
		BaseEnemy.State.AIR_MOVE : NpcStateAirMove,
	}

# 切换NPC状态的函数
# 根据传入的BaseNpc.State枚举值，返回对应状态的实例
func change_state(state:BaseEnemy.State ) -> NpcState:
	# 断言：确保传入的状态在states字典中存在
	assert(states.has(state))
	# 从states字典中获取对应状态的类，并创建其实例
	return states.get(state).new()
