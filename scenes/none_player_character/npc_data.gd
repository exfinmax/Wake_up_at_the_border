# NPC数据管理脚本，负责NPC相关数据的存储和读取
class_name NpcData

var target: Node2D

static func build() -> NpcData:
	return NpcData.new()

func add_player(context_target:Node2D) -> NpcData:
	target = context_target
	return self
