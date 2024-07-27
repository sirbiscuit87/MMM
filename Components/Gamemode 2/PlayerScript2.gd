extends CharacterBody2D

const minSpeed = 300
const maxSpeed = 800
var speed = 300
var acceleration = 0.03
var target = position

# used for preventing unnecessary math
var skin
var hat
var shirt
var facialHair
var legs

func _ready():
	skin = $Sprites/Skin
	hat = $Sprites/Hat
	shirt = $Sprites/Shirt
	facialHair = $"Sprites/Facial Hair"
	legs = $Sprites/Legs
	set_physics_process(false)

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		target = event.get_position()
	elif event is InputEventScreenDrag:
		target = event.get_position()

func _physics_process(_delta):
	if position.distance_to(target) > 150 and speed < maxSpeed:
		speed = speed + speed * acceleration
	elif position.distance_to(target) < 50 and speed > minSpeed:
		speed = speed - speed * acceleration
	
	velocity = position.direction_to(target) * speed
	if velocity.x < 0:
		skin.flip_h = true
		hat.flip_h = true
		shirt.flip_h = true
		facialHair.flip_h = true
		legs.flip_h = true
	elif velocity.x > 0:
		skin.flip_h = false
		hat.flip_h = false
		shirt.flip_h = false
		facialHair.flip_h = false
		legs.flip_h = false
	if position.distance_to(target) > 20:
		move_and_slide()



func _on_gamemode_2_begin_game():
	$"../UI Layer/Debug/ColumnUI/MuteButton/AudioStreamPlayer".play(0)
	set_physics_process(true) # Replace with function body.


func _on_ray_cast_2d_loss():
	$"../UI Layer/Debug/ColumnUI/MuteButton/AudioStreamPlayer".stop()
	set_physics_process(false) # Replace with function body.
