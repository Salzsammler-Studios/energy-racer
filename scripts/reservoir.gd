extends Area2D

@export var MAX_CAPACITY: int       = 100
var currentCapacity: int    = 0
var capacityVelocity: float = 0
var isFilling: bool         = false
var isFull: bool            = true
@onready var animation_player = $AnimationPlayer
@onready var progressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isFilling:
		animation_player.play("Filling")
		var bodies = get_overlapping_bodies()
		if len(bodies) == 1:
			if bodies[0].name == "PlayerCar" or bodies[0].name == "PlayerBycicle":
				capacityVelocity = bodies[0].get_reservoir_filling_rate()
			
		currentCapacity += int(capacityVelocity)
		clampf(currentCapacity, -MAX_CAPACITY, MAX_CAPACITY)
		if currentCapacity < MAX_CAPACITY and currentCapacity > -MAX_CAPACITY:
			isFull = false
			#check if max is reached
		if currentCapacity >= 100 and !isFull:
			isFull = true
			Score.add_bike_score() #Bike
		if currentCapacity <= -100 and !isFull:
			Score.add_car_score() #Car
			isFull = true
		#update progress bar depending on the current value
		var sb = StyleBoxFlat.new()
		progressBar.add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("ff4a8a") if currentCapacity < 0 else Color("76a590")
		progressBar.value = abs(currentCapacity)
	if not isFilling or isFull:
		animation_player.play("Idle")


func _on_body_entered(body):
	if body.name == "PlayerCar" or body.name == "PlayerBycicle":
		isFilling = !isFilling

func _on_body_exited(body):
	if body.name == "PlayerCar" or body.name == "PlayerBycicle":
		isFilling = !isFilling

