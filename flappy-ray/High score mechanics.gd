extends Label

var scores := []

const SAVE_PATH := "user://highscores.save"


func _ready():
	load_scores()
	show_scores()


func add_score(new_score):
	scores.append(new_score)
	scores.sort()
	scores.reverse()
	scores = scores.slice(0, 5)

	save_scores()
	show_scores()


func show_scores():
	visible = true

	var display_text := "High Scores:\n"

	for s in scores:
		display_text += str(s) + "\n"

	text = display_text


func hide_scores():
	visible = false


# 🔥 NEW: hard override to prevent Game Over leaks
func force_hide():
	visible = false


func load_scores():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		scores = file.get_var()
	else:
		scores = []


func save_scores():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(scores)
