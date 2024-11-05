extends CanvasLayer

@onready var carScoreLabel = $PanelContainer3/CarUI/Label
@onready var bikeScoreLabel = $PanelContainer2/BikeUI/Label

@onready var fuelProgressBar = $CarFuelRateUI
@onready var bycicleVelocityUi = $BycicleVelocityUI


@onready var heatlabel = $PanelContainer/HeatUI/Label

var currentHeat : int = 21

const degreeText = 'ºC'
# Called when the node enters the scene tree for the first time.
func _ready():
	currentHeat = 21
	carScoreLabel.text = '0/' + str(Score.VICTORY_SCORE)
	bikeScoreLabel.text = '0/' + str(Score.VICTORY_SCORE)
	heatlabel.text = str(currentHeat)+degreeText
	fuelProgressBar.value = 0
	bycicleVelocityUi.value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	carScoreLabel.text = str(Score.carScore) + '/' + str(Score.VICTORY_SCORE)
	bikeScoreLabel.text = str(Score.bikeScore) + '/' + str(Score.VICTORY_SCORE)
	fuelProgressBar.value = Score.fuelLevel
	bycicleVelocityUi.value = Score.bycicleVelocity
	# todo: decide how to increment Heat Label

func increment_heat_label():
	currentHeat += 1
	heatlabel.text = str(currentHeat)+degreeText
