extends CanvasLayer

@onready var carScoreLabel = $Control/BottomContainer/CarUIPanel/CarScorePanel/CarScore
@onready var bikeScoreLabel = $Control/BottomContainer/BikeUIPanel/BikeScorePanel/BikeScore

@onready var fuelProgressBar = $Control/BottomContainer/CarUIPanel/CarFuelRateUI
@onready var bycicleVelocityUi = $Control/BottomContainer/BikeUIPanel/BikeFuelRateUI


@onready var heatlabel = $Control/TemperaturePanel/HeatUI/Label

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
	# increment by 20 since this value needs to be transformed from 0 to 5 to 0 to 100
	bycicleVelocityUi.value = Score.bycicleVelocity * 20
	# todo: decide how to increment Heat Label

func increment_heat_label():
	currentHeat += 1
	heatlabel.text = str(currentHeat)+degreeText
