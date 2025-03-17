extends CanvasLayer

@onready var countdown_label = $RichTextLabel
@onready var countdown_sound = $"../UIScreen/CountdownAudio"
@onready var arduino_handler = $"../ArduinoHandler"

@onready var is_start_game = false
@onready var is_player_input = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(arduino_handler.GetBikeSpeedMultiplier(), arduino_handler.GetHandOnPlate())
	if is_start_game:
		_startGame()
		pass
	else:
		_idleMode()

# Check if there is pressure on the plate and movement on the bike. If yes, start the game.
func _idleMode():
	if arduino_handler.GetBikeSpeedMultiplier() > 0 && arduino_handler.GetHandOnPlate():
		is_player_input = true
	
	if is_player_input == false:
		# display "Put your hand on the plate and start riding the bike to begin!"
		pass
	else:
		is_start_game = true

func _startGame():
	is_start_game = false
	var countdown_time : int = 3
	get_tree().paused = true
	
	# Update the label immediately with the initial time
	countdown_label.text = str(countdown_time)
	
	# Loop to update the label every second
	while countdown_time > 0:
		await get_tree().create_timer(1).timeout
		countdown_time -= 1
		countdown_label.text = str(countdown_time)
		countdown_sound.play()
	countdown_label.text = "Go!"
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	self.visible = false

