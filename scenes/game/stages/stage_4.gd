extends BaseStage

@onready var memory_pieces = $MemoryPieces.get_children()
@onready var puzzle_ui = $PuzzleUI
var collected = 0

func _ready():
	puzzle_ui.visible = false
	#for piece in memory_pieces:
		#piece.get_node("Area2D").connect("body_entered", Callable(self, "on_piece_collected").bind(piece))

func on_piece_collected(body, piece):
	if body.is_in_group("Player"):
		piece.queue_free()
		collected += 1
		if collected == memory_pieces.size():
			puzzle_ui.visible = true
			# 这里可以添加拼图完成后切换关卡的逻辑 
