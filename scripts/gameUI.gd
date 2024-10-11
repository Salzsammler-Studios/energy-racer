extends CanvasLayer

@onready var carScoreLabel = $PanelContainer3/CarUI/Label
@onready var bikeScoreLabel = $PanelContainer2/BikeUI/Label

@onready var heatlabel = $PanelContainer/HeatUI/Label

const degreeText = 'ºC'
# Called when the node enters the scene tree for the first time.
func _ready():
	carScoreLabel.text = '0/10'
	bikeScoreLabel.text = '0/10'
	heatlabel.text = '28'+degreeText


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	carScoreLabel.text = str(Score.carScore) + '/10'
	bikeScoreLabel.text = str(Score.bikeScore) + '/10'

