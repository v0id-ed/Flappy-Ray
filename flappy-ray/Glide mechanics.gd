extends CharacterBody2D

const GRAVITY = 500.0
const MAX_FALL_SPEED = 120.0
const UP_BOOST = -300.0
const DOWN_BOOST = 250.0

@onready var sprite = $Ray

var dead := false
var original_size := Vector2.ZERO


func _ready():
	original_size = sprite.texture.get_size() * sprite.scale


func _physics_process(delta):
	if dead:
		return

	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, MAX_FALL_SPEED)

	if Input.is_action_just_pressed("ui_up"):
		velocity.y = UP_BOOST

	if Input.is_action_just_pressed("ui_down"):
		velocity.y = DOWN_BOOST

	move_and_slide()

	if get_slide_collision_count() > 0:
		die()


func die():
	if dead:
		return

	dead = true

	var sad_texture = preload("res://Ray dead.png")
	sprite.texture = sad_texture

	var new_size = sad_texture.get_size()
	var scale_factor = original_size / new_size
	sprite.scale = scale_factor

	velocity = Vector2.ZERO

	var canvas = get_tree().get_first_node_in_group("ui_canvas")

	if canvas:
		canvas.stop()

		var score = canvas.get_score()

		var high_scores_label = canvas.get_node_or_null("High scores")

		if high_scores_label:
			high_scores_label.add_score(score)
			high_scores_label.force_hide()

	get_tree().paused = true

	var game_over = preload("res://Game over UI.tscn").instantiate()
	get_tree().current_scene.add_child(game_over)
