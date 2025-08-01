# 游戏事件管理脚本，负责全局事件的定义和触发



extends Node

# 玩家相关信号
signal player_death

# 对话相关信号
signal dialog_end(npc_id: String)
signal get_quest
signal quest_complete
signal all_quest_completed
signal push_quest(npc_id:String, quest_id: String)


# 场景相关信号
signal spawn_spark(position: Vector2)
signal stage_changed  #场景切换完成时触发
signal stage_changing(stage_name: String) #场景开始切换时触发
signal stage_ready(stage_name: String)    #新场景准备完成时触发
signal stage_end

#设置相关信号
signal set_change
signal set_end

signal boss_death
signal boss_start

signal enemy_death(enemy: BaseEnemy)

var is_load_game := false

func dialogue_end(npc_id:String = "") -> void:
	dialog_end.emit(npc_id)
