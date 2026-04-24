extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.name == "Player":
		print("HIT PLAYER") # DEBUG

		get_tree().paused = true

		var game_over = preload("res://Game over UI.tscn").instantiate()
		get_tree().current_scene.add_child(game_over)
