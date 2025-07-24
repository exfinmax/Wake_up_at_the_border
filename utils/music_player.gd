extends AudioStreamPlayer

enum Music {NONE, GAMEPLAY, MENU, STAGE_1, STAGE_2, STAGE_3, STAGE_4, STAGE_5}

const MUSIC_MAP :Dictionary[Music, AudioStream] = {
	Music.GAMEPLAY: null,
	Music.MENU: null,
	Music.STAGE_1: null,
	Music.STAGE_2: null,
	Music.STAGE_3: null,
	Music.STAGE_4: null,
	Music.STAGE_5: null,
}

var current_music := Music.NONE


func _ready() -> void:
	GameEvents.set_change.connect(on_set_change.bind())
	process_mode = Node.PROCESS_MODE_ALWAYS
	bus = "Music"
	
func play_music(music: Music) -> void:
	if music != current_music && MUSIC_MAP.has(music):
		stream = MUSIC_MAP.get(music)
		current_music = music
		play()
		
func on_set_change() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(GameEvents.setting_varrent[0] / 10.0)) 
