extends Area2D

@export var MAX_CAPACITY: float       = 100
var currentCapacity: float    = 0
var capacityVelocity: float = 0
var isFilling: bool         = false
var isFull: bool            = false
@onready var animation_player = $AnimationPlayer
@onready var progressBar = $ProgressBar

@onready var fillSound = $"../FillReservoireAudio"
var sound_played: bool  	= false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isFilling:
		animation_player.play("Filling")
		var bodies = get_overlapping_bodies()
		if len(bodies) == 1:
			if bodies[0].name == "PlayerCar" or bodies[0].name == "PlayerBycicle":
				capacityVelocity = bodies[0].get_reservoir_filling_rate()
			
		currentCapacity += capacityVelocity
		currentCapacity = clampf(currentCapacity, -MAX_CAPACITY, MAX_CAPACITY)
		
		if currentCapacity < MAX_CAPACITY and currentCapacity > -MAX_CAPACITY:
			isFull = false
			#check if max is reached
		if currentCapacity >= MAX_CAPACITY and !isFull:
			isFull = true
			Score.add_bike_score() #Bike
		if currentCapacity <= -MAX_CAPACITY and !isFull:
			Score.add_car_score() #Car
			isFull = true
		#update progress bar depending on the current value
		var sb = StyleBoxFlat.new()
		progressBar.add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("c80827") if currentCapacity < 0 else Color("006fe0")
		progressBar.value = abs(currentCapacity)
	if not isFilling or isFull:
		animation_player.play("Idle")


func _on_body_entered(body):
	if body.name == "PlayerCar" or body.name == "PlayerBycicle":
		isFilling = !isFilling
		if !sound_played && !fillSound.playing: # Play fill sound
			fillSound.play()
			sound_played = true

func _on_body_exited(body):
	if body.name == "PlayerCar" or body.name == "PlayerBycicle":
		isFilling = !isFilling
		sound_played = false  # Reset the flag when the body exits

