class_name PlayerData


var target: Node2D
var num: float

static func build() -> PlayerData:
	return PlayerData.new()

func add_body(Body: Node2D) -> PlayerData:
	target = Body
	return self

func add_number(number:float) -> PlayerData:
	num = number
	return self
