extends Node2D

@export var enemy_scene: PackedScene
@export var background_node: NodePath
@export var player_node: NodePath

@export var min_y := 0.0
@export var max_y := 400.0
@export var spacing := 300.0
@export var spawn_count := 4
@export var despawn_distance := 1200.0

var enemies: Array = []
var bg_scroll
var player
var rng := RandomNumberGenerator.new()


func _ready():
	rng.randomize()

	bg_scroll = get_node_or_null(background_node)
	player = get_node_or_null(player_node)

	if bg_scroll == null:
		push_error("Background not assigned")
		return

	if player == null:
		push_error("Player not assigned")
		return

	var start_x = player.global_position.x + get_viewport().size.x

	for i in range(spawn_count):
		spawn_enemy(start_x + i * spacing)


func _process(delta):
	if bg_scroll == null or player == null:
		return

	var speed = bg_scroll.trees_speed

	for enemy in enemies:
		if enemy:
			enemy.global_position.x -= speed * delta

	for i in range(enemies.size() - 1, -1, -1):
		var enemy = enemies[i]

		if enemy == null:
			continue

		if enemy.global_position.x < player.global_position.x - despawn_distance:
			enemy.queue_free()
			enemies.remove_at(i)

			spawn_enemy(get_rightmost_x() + spacing)


func spawn_enemy(x_pos: float):
	if enemy_scene == null:
		push_error("Enemy scene not assigned")
		return

	var enemy = enemy_scene.instantiate()
	add_child(enemy)

	enemy.global_position.x = x_pos

	var sprite = enemy.get_node("Badnik")
	var half_height = (sprite.texture.get_height() * sprite.scale.y) / 2.0
	var bottom_buffer = 20.0

	enemy.global_position.y = rng.randf_range(
		min_y + half_height,
		max_y - half_height - bottom_buffer
	)

	enemies.append(enemy)


func get_rightmost_x() -> float:
	var furthest = player.global_position.x

	for enemy in enemies:
		if enemy and enemy.global_position.x > furthest:
			furthest = enemy.global_position.x

	return furthest
