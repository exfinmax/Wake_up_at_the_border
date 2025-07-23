class_name PlayerData


var target: Node2D

static func build() -> PlayerData:
	return PlayerData.new()

func add_body(Body: Node2D) -> PlayerData:
	target = Body
	return self
