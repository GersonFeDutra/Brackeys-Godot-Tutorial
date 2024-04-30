extends Node

signal score_changed(int)

const SAVE_FILE := "user://savegame.save"
var score: int:
	set(value):
		var old_score = score
		score = value
		if score > max_score:
			max_score = value
		if value != old_score:
			score_changed.emit(score)
var max_score: int = 0


func _ready() -> void:
	if _save_file_exists():
		load_saved_game()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		save_game()

func _save_file_exists() -> bool:
	return FileAccess.file_exists(SAVE_FILE)


func _gen_encrypt_key() -> PackedByteArray:
	var key = PackedByteArray()
	key.resize(32)
	key.set(1, 1)
	key.set(3, 1)
	key.set(8, 1)
	
	return key


func save_game() -> void:
	# TODO -> Hide the encriptation key
	var save_file = FileAccess.open_encrypted(
		SAVE_FILE, FileAccess.WRITE,
		_gen_encrypt_key())
	
	if save_file == null:
		printerr("Error loading encrypted save file ",
				FileAccess.get_open_error())
		return
	
	var game_data := {
		max_score = max_score,
	}
	var json_string = JSON.stringify(game_data)
	save_file.store_line(json_string)
	
	save_file.close()


func load_saved_game() -> void:
	assert(_save_file_exists(), "save file does not exists")
	var json = JSON.new()
	var save_file = FileAccess.open_encrypted(
			SAVE_FILE, FileAccess.READ,
			_gen_encrypt_key())
	
	if save_file == null:
		printerr("Error loading encrypted save file ",
			FileAccess.get_open_error())
		return
	
	var json_string = save_file.get_as_text()
	var parse_result = json.parse_string(json_string)
	
	if not parse_result:
		printerr("JSON Parse Error: ",
				json.get_error_message(),
				" in ", json_string,
				" at line ", json.get_error_line())
	else:
		max_score = parse_result.max_score
	
	save_file.close()
