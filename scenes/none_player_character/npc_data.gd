class_name NpcData

var target: Node2D

static func build() -> NpcData:
	return NpcData.new()

func add_player(context_target:Node2D) -> NpcData:
	target = context_target
	return self
