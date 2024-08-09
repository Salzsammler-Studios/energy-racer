extends Node

var game_over_scene = preload("res://scenes/UI/winScreenUI.tscn")

enum possibleVictoryReasons {forfeit, points}
var currentVictoryReason: possibleVictoryReasons
var currentVictoryReasonString: String

enum possibleVictors {car, bycicle}
var currentVictor: possibleVictors
var currentVictorString: String

# Go to the win screen, showing the victor and the reason they won. 0 is by forfeit, 1 is by points.
func win_screen(victoryReason : possibleVictoryReasons, victor : possibleVictors):
	currentVictoryReason = victoryReason
	currentVictoryReasonString = str(possibleVictoryReasons.keys()[currentVictoryReason])
	currentVictor = victor
	currentVictorString = str(possibleVictors.keys()[currentVictor])

	print(str(possibleVictors.keys()[currentVictor])," wins by ", str(possibleVictoryReasons.keys()[currentVictoryReason]))
	get_tree().change_scene_to_packed(game_over_scene)
