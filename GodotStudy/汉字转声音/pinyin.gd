extends Node
static var pinyin_dict = {}
const SHENG_MU = ["b", "p", "m", "f", "d", "t", "n", "l", "g", "k", "h", "j", "q", "x", "r", "y", "w"]

func _ready() -> void:
	load_pinyin_file("res://汉字转声音/CEDICT2JSON-master/cedict.json")

func load_pinyin_file(path: String) -> void:
	if pinyin_dict:
		return
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		file.close()
		return
	var pinyin_array:Array= JSON.parse_string(file.get_as_text())
	file.close()
	for item in pinyin_array:
		pinyin_dict[item["simplified"]] = item["pinyin"]

func get_pinyin(text: String) -> String:
	var result = ""
	for c in text:
		if pinyin_dict.has(c):
			result += pinyin_dict.get(c) + " "
		else:
			result += c + " "
	return result.strip_edges()

func pinyin_parse(pinyin: String, min_speak_speed = .1, max_speak_speed = .1) -> void:
	for i in pinyin.split(" "):
		var audio_path: String
		if i[0] == "a":
			if i.length() == 1:
				audio_path = "res://汉字转声音/audio/a.wav"
			elif i[1] == 'n':
				if i[2] == 'g':
					audio_path = "res://汉字转声音/audio/ang.wav"
				else:
					audio_path = "res://汉字转声音/audio/an.wav"
			else:
				audio_path = "res://汉字转声音/audio/a" + i[1] + ".wav"
		elif i[0] == "e":
			if i.length() == 1:
				audio_path = "res://汉字转声音/audio/e.wav"
			elif i[1] == 'n':
				if i[2] == 'g':
					audio_path = "res://汉字转声音/audio/eng.wav"
				else:
					audio_path = "res://汉字转声音/audio/en.wav"
			else:
				audio_path = "res://汉字转声音/audio/e" + i[1] + ".wav"
		elif i[0] == "o":
			if i.length() == 1:
				audio_path = "res://汉字转声音/audio/o.wav"
			else:
				audio_path = "res://汉字转声音/audio/o" + i[1] + ".wav"
		elif i[0] == "z":
			if i.length() == 1:
				audio_path = "res://汉字转声音/audio/z.wav"
			else:
				audio_path = "res://汉字转声音/audio/z" + i[1] + ".wav"
		elif i[0] == "c":
			if i.length() == 1:
				audio_path = "res://汉字转声音/audio/c.wav"
			else:
				audio_path = "res://汉字转声音/audio/c" + i[1] + ".wav"
		elif i[0] == "s":
			if i.length() == 1:
				audio_path = "res://汉字转声音/audio/s.wav"
			else:
				audio_path = "res://汉字转声音/audio/s" + i[1] + ".wav"
		elif i[0] in SHENG_MU:
			audio_path = "res://汉字转声音/audio/" + i[0] + ".wav"
		else:
			audio_path = ""
		if audio_path != "":
			create_audio(load(audio_path))

		await get_tree().create_timer(randf_range(min_speak_speed, max_speak_speed)).timeout

func create_audio(wav: AudioStreamWAV, audio_bus:StringName = "Master",min_pitch=0.9,max_pitch=1.4) -> void:
	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	audio_player.stream = wav
	audio_player.bus = audio_bus
	audio_player.pitch_scale = randf_range(min_pitch, max_pitch)
	audio_player.play()
	audio_player.finished.connect(func(): audio_player.queue_free())
