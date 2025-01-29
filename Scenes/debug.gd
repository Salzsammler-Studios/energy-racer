extends Node2D
## Features: Disables forfeit
## @experimental: activating might cause unexpected behavior due to dependencies
@export var debugMode: bool =  false 

func _ready():
	if debugMode == false:
		pass
	else:
		Score.disableForfeit = true
		# Add more conditions here if necessary. Stick to the formula.


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
