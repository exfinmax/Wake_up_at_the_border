# NPC状态工厂，负责创建和管理NPC的不同状态
class_name NpcStateFactory

# 存储所有NPC状态的词典
# 键：BaseNpc.State枚举值
# 值：对应状态的类
var states: Dictionary = {}

# 初始化函数
# 在NPC状态工厂创建时调用
# 初始化所有基础状态，并存储在states字典中
func _init() -> void:
	states = {
		BaseNpc.State.MOVE : NpcStateMove,    # 移动状态
		BaseNpc.State.AIR : NpcStateAir,      # 空中状态
		BaseNpc.State.ATTACK : NpcStateAttack,# 攻击状态
		BaseNpc.State.HURT : NpcStateHurt,    # 受伤状态
		BaseNpc.State.DEFEND : NpcStateDefend,# 防御状态
		BaseNpc.State.IDLE : NpcStateIdle,    # 待机状态
		BaseNpc.State.SPECIAL : NpcStateSpecial# 特殊状态（仅用于特定NPC）
	}

# 切换NPC状态的函数
# 根据传入的BaseNpc.State枚举值，返回对应状态的实例
func change_state(state:BaseNpc.State ) -> NpcState:
	# 断言：确保传入的状态在states字典中存在
	assert(states.has(state))
	# 从states字典中获取对应状态的类，并创建其实例
	return states.get(state).new()
