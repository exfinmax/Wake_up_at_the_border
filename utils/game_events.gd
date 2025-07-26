# 游戏事件管理脚本，负责全局事件的定义和触发



extends Node

# 玩家相关信号
signal player_death

# 对话相关信号
signal dialog_end
signal get_quest
signal quest_complete

# 场景相关信号
signal stage_changed  #场景切换完成时触发
signal stage_changing(stage_name: String) #场景开始切换时触发
signal stage_ready(stage_name: String)    #新场景准备完成时触发
signal stage_end

#设置相关信号
signal set_change
signal set_end
