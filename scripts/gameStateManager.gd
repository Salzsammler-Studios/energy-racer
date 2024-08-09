extends Node

var game_over_scene = preload("res://scenes/UI/winScreenUI.tscn")

enum possibleVictoryReasons {forfeit, points}
var currentVictoryReason: possibleVictoryReasons

enum possibleVictors {car, bycicle}
var currentVictor: possibleVictors

# Go to the win screen, showing the victor and the reason they won. 0 is by forfeit, 1 is by points.
func win_screen(victoryReason : possibleVictoryReasons, victor : possibleVictors):
	currentVictoryReason = victoryReason
	currentVictor = victor

	print(str(possibleVictors.keys()[currentVictor])," wins by ", str(possibleVictoryReasons.keys()[currentVictoryReason]))
	get_tree().change_scene_to_packed(game_over_scene)
