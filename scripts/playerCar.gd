extends CharacterBody2D

@export var MAX_SPEED: int = 400
@export var MIN_SPEED: int = 10
var speed : int     = 400  # speed in pixels/sec
const MAX_FUEL: int = 100
var currentFuelCapacity: float = 100
@export var fuelDepletionRate : float          = 1 # fuel depletion in sec
@export var isFilling : bool = false

@onready var screen_size = get_viewport_rect().size 
@onready var arduino_handler = $ArduinoHandler
var carScore: int = 0


func _process(_delta):
	arduino_handler.SetRefuelling(isFilling)
	Score.update_fuel_level(currentFuelCapacity)
		
		
func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	# process oil usage
	currentFuelCapacity = currentFuelCapacity - (fuelDepletionRate * delta)
	currentFuelCapacity = clampf(currentFuelCapacity, 5,MAX_FUEL)
	
	speed = maxi(MAX_SPEED * (currentFuelCapacity/100),MIN_SPEED)
	velocity = direction * speed
	if direction.length() != 0:
		rotation = lerp_angle(rotation, velocity.angle(), 0.25)
	move_and_slide()
	
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
	return minf((currentFuelCapacity / MAX_FUEL * -1),-0.1)

func fill_gas_tank(amount: float):
	currentFuelCapacity += amount
