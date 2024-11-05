extends Node

var game_over_scene = preload("res://scenes/UI/winScreenUI.tscn")

var bikeScore: int = 0
var carScore: int = 0

var winner : String = 'nobody'
var BIKE_RESERVOIR_FILL_SCORE = 1
var CAR_RESERVOIR_FILL_SCORE = 1

var VICTORY_SCORE: int = 15

var victoryByPoints: bool = true

var fuelLevel: float = 100
var bycicleVelocity: float = 100

### debug variables ###
var disableForfeit: bool = false

func add_bike_score():
	bikeScore += BIKE_RESERVOIR_FILL_SCORE
	print(bikeScore)
	if bikeScore >= VICTORY_SCORE:
		winner = 'FAHRRAD'
		get_tree().change_scene_to_packed(game_over_scene)
	
func add_car_score():
	carScore += CAR_RESERVOIR_FILL_SCORE
	if carScore >= VICTORY_SCORE:
		winner = 'AUTO'
		get_tree().change_scene_to_packed(game_over_scene)
		
func car_forfeit():
	if disableForfeit == true:
		pass
	else:
		Score.winner = 'FAHRRAD'
		victoryByPoints = false
		get_tree().change_scene_to_packed(game_over_scene)
	
func bike_forfeit():
	if disableForfeit == true:
		pass
	else:
		Score.winner = 'AUTO'
		victoryByPoints = false
		get_tree().change_scene_to_packed(game_over_scene)

func reset_score():
	winner = 'nobody'
	bikeScore = 0
	carScore = 0

func update_fuel_level(value: float):
	fuelLevel = value

func update_bycicle_velocity(value: float):
	bycicleVelocity = value
