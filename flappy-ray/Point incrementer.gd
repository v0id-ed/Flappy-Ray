extends CanvasLayer

@onready var label = $Points

var score := 0
var running := false
var time_accumulator := 0.0

# blinking
var blinking := false
var blink_timer := 0.0
var blink_interval := 0.5


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_label()


func _process(delta):
	if running:
		time_accumulator += delta

		if time_accumulator >= 1.0:
			time_accumulator = 0.0
			score += 5
			update_label()

	if blinking:
		blink_timer += delta

		if blink_timer >= blink_interval:
			blink_timer = 0.0
			label.visible = !label.visible


func update_label():
	label.text = str(score)


func start():
	score = 0
	time_accumulator = 0.0
	running = true
	blinking = false
	label.visible = true
	update_label()


func stop():
	running = false
	blinking = true
	blink_timer = 0.0


func get_score():
	return score
