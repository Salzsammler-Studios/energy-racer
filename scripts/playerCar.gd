extends CharacterBody2D

const MAX_SPEED = 400
var speed : int = 400  # speed in pixels/sec
const MAX_FUEL = 100
@export var currentFuelCapacity = 100
var fuelDepletionRate = 1 # fuel depletion in sec


func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	# process oil usage
	currentFuelCapacity = currentFuelCapacity - (fuelDepletionRate * delta)
	clamp(currentFuelCapacity,5,MAX_FUEL)
	
	speed = MAX_SPEED * (currentFuelCapacity/100)
	velocity = direction * speed
	rotation = lerp_angle(rotation, velocity.angle(), 0.25)

	move_and_slide()


func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func get_reservoir_filling_rate():
	return currentFuelCapacity / MAX_FUEL * -1

func fill_gas_tank(amount: float):
	currentFuelCapacity += amount
	print(currentFuelCapacity)
