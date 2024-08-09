extends Area2D

var MAX_CAPACITY: int       = 100
var currentCapacity: int    = 0
var capacityVelocity: float = 0
var isFilling: bool         = false

var BIKE_RESERVOIR_FILL_SCORE = 2
var CAR_RESERVOIR_FILL_SCORE = 1

@onready var progressBar = $ProgressBar
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isFilling:
		if currentCapacity <= MAX_CAPACITY and currentCapacity >= -MAX_CAPACITY:
			currentCapacity += capacityVelocity
			
			#check if max is reached
			if currentCapacity >= 100:
				Score.add_bike_score() #Bike
			if currentCapacity <= -100:
				Score.add_car_score() #Car

		#update progress bar depending on the current value
		var sb = StyleBoxFlat.new()
		progressBar.add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("ff4a8a") if currentCapacity < 0 else Color("76a590")
		progressBar.value = abs(currentCapacity)


func _on_body_entered(body):
	if body.name == "PlayerCar" or body.name == "PlayerBycicle":
		isFilling = !isFilling
		capacityVelocity = body.get_reservoir_filling_rate()

func _on_body_exited(body):
	if body.name == "PlayerCar" or body.name == "PlayerBycicle":
		isFilling = !isFilling

