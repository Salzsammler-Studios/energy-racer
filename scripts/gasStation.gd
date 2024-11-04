extends Area2D

var isFilling = false
@export var fillRate = 4
@onready var playerCar = $"../../PlayerCar"
@onready var animation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isFilling:
		playerCar.isFilling = true
		playerCar.fill_gas_tank(fillRate * delta)
		animation_player.play("Filling")
		

func _on_body_entered(body):
	if body.name == "PlayerCar":
		isFilling = true
		

func _on_body_exited(body):
	if body.name == "PlayerCar":
		isFilling = false
		playerCar.isFilling = false
		animation_player.play("Idle")
