extends Control

@onready var start_button = $Startbutton
@onready var high_scores = $"CanvasLayer/High scores"

func _ready():
	get_tree().paused = true
	start_button.pressed.connect(_on_start_pressed)

	if high_scores:
		high_scores.load_scores()
		high_scores.show_scores()


func _on_start_pressed():
	visible = false

	if high_scores:
		high_scores.hide_scores()

	var canvas = get_tree().get_first_node_in_group("ui_canvas")
	if canvas:
		canvas.start()

	get_tree().paused = false
