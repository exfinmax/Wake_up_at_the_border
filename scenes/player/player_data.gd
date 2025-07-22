class_name PlayerData


var target: Node2D

static func build() -> PlayerData:
	return PlayerData.new()

func add_target(context_target:Node2D) -> PlayerData:
	target = context_target
	return self
