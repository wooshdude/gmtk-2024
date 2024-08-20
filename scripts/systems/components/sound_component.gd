extends Node
class_name SoundComponent

@export var sounds: Array[Sound]

func play(sound_name:String = ""):
	if sound_name == "": sound_name = sounds[0].sound_name
	for s:Sound in sounds:
		if s.sound_name == sound_name:
			print("Playing %s" % sound_name)
			var new_audio_stream = AudioStreamPlayer.new()
			new_audio_stream.stream = s.sounds.pick_random()
			new_audio_stream.autoplay = true
			new_audio_stream.volume_db = s.volume_db
			self.add_child(new_audio_stream)
			await new_audio_stream.finished
			new_audio_stream.queue_free()
