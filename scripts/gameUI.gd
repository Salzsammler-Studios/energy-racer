extends CanvasLayer


@onready var CarScoreText = $PanelContainer3/CarUI/Label
@onready var BikeScoreText = $PanelContainer2/BikeUI/Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CarScoreText.text = str(Score.carScore)
	BikeScoreText.text = str(Score.bikeScore)

