
extends Screen
class_name WorldScreen

# 场景路径常量
const STAGE_PATH := "res://scenes/stages/"
const STAGE_PREFIX := "stage_"

# 场景预加载缓存
var _stage_cache := {}
# 当前场景实例
var _current_stage: Node = null
# 是否正在切换场景
var _is_transitioning := false

func _ready() -> void:
	# 预加载所有场景
	_preload_stages()
	change_stage("stage_1")
	GameEvents.stage_end.connect(next_stage.bind())
	
# 预加载所有场景到缓存
func _preload_stages() -> void:
	var dir = DirAccess.open(STAGE_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				var stage_name = file_name.get_basename()
				var stage_path = STAGE_PATH + file_name
				_stage_cache[stage_name] = load(stage_path)
			file_name = dir.get_next()
		dir.list_dir_end()

# 切换到指定场景
func change_stage(stage_name: String) -> void:
	if _is_transitioning:
		return
		
	_is_transitioning = true
	GameEvents.stage_changing.emit(stage_name)
	
	# 如果有当前场景，先清理
	if _current_stage:
		_current_stage.queue_free()
	
	# 从缓存加载新场景
	var stage_scene = _stage_cache.get(stage_name)
	if not stage_scene:
		push_error("Stage not found: " + stage_name)
		_is_transitioning = false
		return
	
	# 实例化新场景
	_current_stage = stage_scene.instantiate()
	add_child(_current_stage)
	
	# 更新全局状态
	Global.current_stage = stage_name
	
	# 发送信号
	GameEvents.stage_ready.emit(stage_name)
	GameEvents.stage_changed.emit(stage_name)
	_is_transitioning = false

# 切换到下一个场景
func next_stage() -> void:
	if not Global.current_stage:
		change_stage(STAGE_PREFIX + "1")
		return
		
	var current_number = int(Global.current_stage.trim_prefix(STAGE_PREFIX))
	var next_stage = STAGE_PREFIX + str(current_number + 1)
	
	if _stage_cache.has(next_stage):
		change_stage(next_stage)
	else:
		push_warning("No next stage available after: " + Global.current_stage)

# 重新加载当前场景
func reload_current_stage() -> void:
	if Global.current_stage:
		change_stage(Global.current_stage)

# 获取场景总数
func get_stage_count() -> int:
	return _stage_cache.size()

# 检查场景是否存在
func has_stage(stage_name: String) -> bool:
	return _stage_cache.has(stage_name)

# 获取当前场景实例
func get_current_stage() -> Node:
	return _current_stage

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("set"):
		transition_state(TheGame.ScreenType.SETTING)
