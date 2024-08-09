extends Area2D

var MAX_CAPACITY: int       = 100
var currentCapacity: int    = 0
var capacityVelocity: float = 1
var isFilling: bool         = false

@onready var progressBar = $ProgressBar
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isFilling:
		currentCapacity += capacityVelocity
		clamp(currentCapacity,-100, 100)
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
