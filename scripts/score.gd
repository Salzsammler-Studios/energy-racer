extends Node

var game_over_scene = preload("res://scenes/UI/winScreenUI.tscn")

var bikeScore: int = 0
var carScore: int = 0

var BIKE_RESERVOIR_FILL_SCORE = 2
var CAR_RESERVOIR_FILL_SCORE = 1

var VICTORY_SCORE: int = 10

func add_bike_score():
	bikeScore += BIKE_RESERVOIR_FILL_SCORE
	print(bikeScore)
	if bikeScore >= VICTORY_SCORE:
		get_tree().change_scene_to_packed(game_over_scene)
	
func add_car_score():
	carScore += CAR_RESERVOIR_FILL_SCORE
	if carScore >= VICTORY_SCORE:
		get_tree().change_scene_to_packed(game_over_scene)

