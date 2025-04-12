extends Node

func _on_line_edit_text_submitted(new_text: String) -> void:
	var pinyin = Pinyin.get_pinyin(new_text)
	Pinyin.pinyin_parse(pinyin)
