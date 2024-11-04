extends CanvasLayer

@onready var carScoreLabel = $PanelContainer3/CarUI/Label
@onready var bikeScoreLabel = $PanelContainer2/BikeUI/Label

@onready var fuelProgressBar = $CarFuelRateUI
@onready var bycicleVelocityUi = $BycicleVelocityUI


@onready var heatlabel = $PanelContainer/HeatUI/Label


const degreeText = 'ºC'
# Called when the node enters the scene tree for the first time.
func _ready():
	carScoreLabel.text = '0/10'
	bikeScoreLabel.text = '0/10'
	heatlabel.text = '28'+degreeText
	fuelProgressBar.value = 0
	bycicleVelocityUi.value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	carScoreLabel.text = str(Score.carScore) + '/10'
	bikeScoreLabel.text = str(Score.bikeScore) + '/10'
	fuelProgressBar.value = Score.fuelLevel
	bycicleVelocityUi.value = Score.bycicleVelocity
	# todo: decide how to increment Heat Label

