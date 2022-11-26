class_name HighScoreSave
extends Resource

export var high_score: int = 0
export var second_score: int = 0
export var third_score: int = 0

const SAVE_PATH := "user://highscore_save.tres"

func write_highscore() -> void:
	ResourceSaver.save(SAVE_PATH, self)


func check_and_update_score(score: int) -> void:
	if score > high_score:
		third_score = second_score
		second_score = high_score
		high_score = score
	elif score > second_score:
		third_score = second_score
		second_score = score
	elif score > third_score:
		third_score = score


static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_PATH)


static func load_highscore_save() -> Resource:
	return ResourceLoader.load(SAVE_PATH, "", true)
