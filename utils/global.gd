# 全局变量脚本，负责存储全局可访问的数据
extends Node

# 玩家对象，用于存储当前游戏中的玩家实例
# （如需了解详细信息，请参考Player类）
var player: Player = null
var player_skill:Array = [false, false, false, false, false]

# 当前场景名称
var current_stage: String = ""
var current_scene: Node
var current_screen: Screen

var loader_screen: LoaderScreen

var current_setting:Dictionary = {
	"Master": null,
	"BGM": null,
	"SFX": null,
	"shake_strength": null,
	"unlock_end": [],
}
