# 全局变量脚本，负责存储全局可访问的数据
extends Node

# 玩家对象，用于存储当前游戏中的玩家实例
# （如需了解详细信息，请参考Player类）
var player: Player = null
var player_skill:Array = [false, false, false, false, false, false, false]
var camera: Camera2D

# 当前场景名称
var current_stage: String = ""
var current_scene: Node
var current_screen: Screen

var loader_screen: LoaderScreen

var load_time:Array = [0, 0, 0, 0, 0, 0]

var is_first_talk_2:bool = false
var is_first_talk_3:bool = false
var is_first_talk_4:bool = false

var unlock_end1:bool = false
var unlock_end2:bool = false
var unlock_end3:bool = false

var screct1:bool = false
var screct2:bool = false




var current_setting:Dictionary = {
	"Master": null,
	"BGM": null,
	"SFX": null,
}
