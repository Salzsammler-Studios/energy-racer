extends Node

var bikeScore: int = 0
var carScore: int = 0

var BIKE_RESERVOIR_FILL_SCORE = 2
var CAR_RESERVOIR_FILL_SCORE = 1

func add_bike_score():
	bikeScore += BIKE_RESERVOIR_FILL_SCORE
	print(bikeScore)
	
func add_car_score():
	carScore += CAR_RESERVOIR_FILL_SCORE
