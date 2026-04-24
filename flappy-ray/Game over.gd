extends Control

func _ready():
	# Connect the pressed signal
	$Restartbutton.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
