extends Node
class_name AudioManager

@export var score_sounds : Array[AudioStream] 
@export var sounds_with_objectives : Dictionary[int, AudioStream]
var audio: AudioStreamPlayer3D

func _ready() -> void:
	audio = AudioStreamPlayer3D.new()
	add_child(audio)
	Global.updated_score.connect(_play_score)
	Global.updated_objective.connect(
		func(scene_id):
		print(scene_id)
		if sounds_with_objectives.has(scene_id):
			print("found")
			var stream = sounds_with_objectives[scene_id]
			audio.stream = stream
			audio.volume_db = 10.0
			audio.play()
		)
	
	
func _play_score(score):
	Play()

func Play():
	var random = RandomNumberGenerator.new()
	var stream = score_sounds[random.randi_range(0,score_sounds.size()-1)]
	audio.stream = stream
	audio.volume_db = 10.0
	audio.play()
