extends Node2D

var speed_min = 50
var speed_max = 150
var speed = 0

func _ready():
	# Set a random speed between speed_min and speed_max
	speed = randf_range(speed_min, speed_max)

func _process(delta):
	# Move the clouds to the left and delete upon exit of screen
	var movement = Vector2.RIGHT * speed * delta
	translate(movement)
	if global_position.x >= 1600:
		queue_free()

