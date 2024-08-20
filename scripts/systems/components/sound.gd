extends Resource
class_name Sound

@export var sound_name:String
@export var sounds: Array[AudioStream]
@export_range(-80,24,0.1) var volume_db: float = 0.0
