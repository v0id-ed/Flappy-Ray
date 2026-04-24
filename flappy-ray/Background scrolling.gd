extends Node2D

# ---- Sprite node base names ----
var ocean_base_name := "ocean"
var trees_base_name := "trees"

# ---- Scroll speeds (pixels/sec) ----
var ocean_speed := 100.0
var trees_speed := 150.0

# ---- Acceleration (pixels/sec²) ----
var ocean_acceleration := 1.5
var trees_acceleration := 2.5

# ---- Sprite arrays ----
var oceans := []
var trees := []

# Widths (auto-detected)
var ocean_width := 0.0
var trees_width := 0.0

# Overlap buffer to prevent gaps
const BUFFER := 2.0


func _ready():
	# --- Setup ocean sprites ---
	for i in range(3):
		var ocean = get_node("%s%d" % [ocean_base_name, i + 1])
		oceans.append(ocean)

	ocean_width = oceans[0].texture.get_width() * oceans[0].scale.x

	# Position side by side
	for i in range(3):
		oceans[i].position.x = oceans[0].position.x + i * ocean_width


	# --- Setup tree sprites ---
	for i in range(3):
		var tree = get_node("%s%d" % [trees_base_name, i + 1])
		trees.append(tree)

	trees_width = trees[0].texture.get_width() * trees[0].scale.x

	# Position side by side
	for i in range(3):
		trees[i].position.x = trees[0].position.x + i * trees_width


func _process(delta):
	# ---- Slowly increase speed ----
	ocean_speed += ocean_acceleration * delta
	trees_speed += trees_acceleration * delta

	# ---- Determine left edge safely ----
	var camera_left = 0.0
	var cam = get_viewport().get_camera_2d()
	if cam:
		camera_left = cam.global_position.x - get_viewport().size.x / 2

	# ---- Move and loop oceans ----
	for ocean in oceans:
		# Move
		ocean.position.x -= ocean_speed * delta

		# SNAP TO PIXELS (fix gaps)
		ocean.position.x = round(ocean.position.x)

		# Loop
		while ocean.position.x + ocean_width < camera_left - BUFFER:
			var rightmost = oceans[0]
			for o in oceans:
				if o.position.x > rightmost.position.x:
					rightmost = o

			# Apply overlap buffer
			ocean.position.x = rightmost.position.x + ocean_width - BUFFER


	# ---- Move and loop trees ----
	for tree in trees:
		# Move
		tree.position.x -= trees_speed * delta

		# SNAP TO PIXELS (fix gaps)
		tree.position.x = round(tree.position.x)

		# Loop
		while tree.position.x + trees_width < camera_left - BUFFER:
			var rightmost = trees[0]
			for t in trees:
				if t.position.x > rightmost.position.x:
					rightmost = t

			# Apply overlap buffer
			tree.position.x = rightmost.position.x + trees_width - BUFFER
