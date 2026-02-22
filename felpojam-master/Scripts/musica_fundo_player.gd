extends AudioStreamPlayer

var musica_audio_stream = AudioStreamPlayer.new() 

const bg_music = preload("res://Sons/lofi.mp3")

func _play_music(music: AudioStream, volume = 1):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()
	
func play_music_level():
	_play_music(bg_music)

#n sei ainda
#func stop_music_level(music: AudioStream):
	#musica_audio_stream.stop()
