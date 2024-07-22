extends CharacterBody2D

var speed : int = 400  # speed in pixels/sec
var acceleration = 1.1 # velocity based on the cycling speed

func _physics_process(delta):
	if Input.is_action_pressed("accellerate"):
		acceleration = 2
	else:
		acceleration = 1
	var direction = Input.get_vector("left2", "right2", "up2", "down2")
	velocity = direction * speed * acceleration
	rotation = lerp_angle(rotation, velocity.angle(), 0.25)

	move_and_slide()


func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func get_reservoir_filling_rate():
	return acceleration
