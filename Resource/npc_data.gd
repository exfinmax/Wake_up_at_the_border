# NPC数据类，用于在状态之间传递数据
class_name NpcData
extends RefCounted

# 数据存储
var target: Node2D = null          # 目标对象（如玩家）
var custom_data: Dictionary = {}    # 自定义数据字典

# 构建器模式方法
static func build() -> NpcData:
	return NpcData.new()

# 添加玩家引用
func add_player(player: Node2D) -> NpcData:
	target = player
	return self

# 添加自定义数据
func add_data(key: String, value: Variant) -> NpcData:
	custom_data[key] = value
	return self

# 获取自定义数据，如果不存在返回默认值
func get_data(key: String, default_value: Variant = null) -> Variant:
	return custom_data.get(key, default_value)

# 检查是否存在某个数据
func has_data(key: String) -> bool:
	return custom_data.has(key)

# 移除数据
func remove_data(key: String) -> void:
	custom_data.erase(key)

# 清除所有数据
func clear_data() -> void:
	custom_data.clear()
	target = null

# 获取所有数据的副本
func get_all_data() -> Dictionary:
	var data := custom_data.duplicate()
	data["target"] = target
	return data
