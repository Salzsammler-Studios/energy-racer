extends CharacterBody2D

const MAX_SPEED: int = 400
const MIN_SPEED: int = 10
var speed : int     = 400  # speed in pixels/sec
const MAX_FUEL: int = 100
var currentFuelCapacity: float = 100
var fuelDepletionRate : float          = 1 # fuel depletion in sec
var isFilling : bool = false

@onready var arduino_handler = $ArduinoHandler
var carScore: int = 0


func _process(delta):
	arduino_handler.SetRefuelling(isFilling)
		
		
func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	# process oil usage
	currentFuelCapacity = currentFuelCapacity - (fuelDepletionRate * delta)
	currentFuelCapacity = maxf(5,MAX_FUEL)
	
	speed = maxf(MAX_SPEED * (currentFuelCapacity/100),MIN_SPEED)
	velocity = direction * speed
	rotation = lerp_angle(rotation, velocity.angle(), 0.25)

	move_and_slide()

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
