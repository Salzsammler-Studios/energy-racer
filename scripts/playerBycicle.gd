extends CharacterBody2D

var speed : int = 400  # speed in pixels/sec
var acceleration = 1.1 # velocity based on the cycling speed

func _physics_process(delta):
	if Input.is_action_pressed("accellerate"):
		acceleration = 2
	else:
		acceleration = 1
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed * acceleration

	move_and_slide()
