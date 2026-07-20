extends Node
class_name AudioManager

@export var score_sounds : Array[AudioStream] 
var audio: AudioStreamPlayer3D

func _ready() -> void:
	audio = AudioStreamPlayer3D.new()
	add_child(audio)
	
	Global.add_score.connect(_play_score)
	
func _play_score(i):
	Play()

func Play():
	var random = RandomNumberGenerator.new()
	var stream = score_sounds[random.randi_range(0,score_sounds.size()-1)]
	audio.stream = stream
	audio.play()
