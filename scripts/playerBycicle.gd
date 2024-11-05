extends CharacterBody2D

@export var speed : int         = 400  # speed in pixels/sec
var acceleration: int = 1 # velocity based on the cycling speed
@onready var screen_size = get_viewport_rect().size 
@onready var animatedSprite = $AnimatedSprite2D
@onready var arduino_handler = $"../ArduinoHandler"
var angle = 0

var countdown : float = 0
@export var grace_period : float = 4.0 #time the bike may stand still before forfeit

func _ready():
	countdown = grace_period

func _physics_process(_delta):
	acceleration = arduino_handler.GetBikeSpeedMultiplier()
	print("Speed multiplier of bike: ", acceleration)
	check_for_forfeit(_delta)
	var direction: Vector2 = Input.get_vector("left2", "right2", "up2", "down2")
	velocity = direction * speed * acceleration
	move_and_slide()
	Score.update_bycicle_velocity(acceleration)
	
	# figure out directional angle
	if direction.length() != 0:
		angle = direction.angle() / (PI/4)
		angle = wrapi(int(angle), 0, 8)
	animatedSprite.play(str(angle))
	
	#Wrap movement around the screen so that if they leave the screen they appear at the other side
	position.x = wrapf(position.x, -screen_size.x/1.25, screen_size.x/1.25)
	position.y = wrapf(position.y, -screen_size.y/1.25, screen_size.y/1.25)

func short_angle_dist(from, to):
	var max_angle: float  = PI * 2
	var difference: float = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

#todo: maybe change this. needs to be designed
func get_reservoir_filling_rate():
	return acceleration

func check_for_forfeit(delta):
	if acceleration <= 0:
		countdown -= delta
		if countdown <= 0:
			print("bike forfeit")
	else:
		countdown = grace_period
