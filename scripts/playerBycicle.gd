extends CharacterBody2D

@export var speed : int         = 400  # speed in pixels/sec
var acceleration: float = 1.1 # velocity based on the cycling speed
@onready var screen_size = get_viewport_rect().size 

func _physics_process(_delta):
	if Input.is_action_pressed("accellerate"):
		acceleration = 2
	else:
		acceleration = 1
	var direction: Vector2 = Input.get_vector("left2", "right2", "up2", "down2")
	velocity = direction * speed * acceleration
	rotation = lerp_angle(rotation, velocity.angle(), 0.25)
	move_and_slide()
	Score.update_bycicle_velocity(acceleration)
	
	#Wrap movement around the screen so that if they leave the screen they appear at the other side
	position.x = wrapf(position.x, -screen_size.x/1.25, screen_size.x/1.25)
	position.y = wrapf(position.y, -screen_size.y/1.25, screen_size.y/1.25)

func short_angle_dist(from, to):
	var max_angle: float  = PI * 2
	var difference: float = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight


func get_reservoir_filling_rate():
	return acceleration
