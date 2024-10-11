extends CanvasLayer

@onready var countdown_label = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var countdown_time : int = 3
	get_tree().paused = true
	
	# Update the label immediately with the initial time
	countdown_label.text = str(countdown_time)
	
	# Loop to update the label every second
	while countdown_time > 0:
		await get_tree().create_timer(1).timeout
		countdown_time -= 1
		countdown_label.text = str(countdown_time)
	countdown_label.text = "Go!"
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
