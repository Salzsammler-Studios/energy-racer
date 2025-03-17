extends CanvasLayer
@onready var winScreenLabel = $Control/Control/Panel/WinnerLabel
@onready var winConditionLabel = $Control/Control/Panel/LoserLabel
@onready var playAgainButton = $Control/Control/VBoxContainer/ButtonReset
var gameScene = preload("res://Scenes/world.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var loser = 'Auto'
	if Score.winner == 'Auto':
		loser = 'Fahrrad'
	winScreenLabel.text = '[center]' + Score.winner+' HAT GEWONNEN'
	if Score.victoryByPoints == true:
		winConditionLabel.text = '[center] Auto: '+str(Score.carScore)+'    Fahrrad: '+str(Score.bikeScore)
	else:
		winConditionLabel.text = '[center]'+str(loser)+ ' hat aufgegeben'
		pass
	playAgainButton.grab_focus()
	
func _on_reset_button_pressed():
	Score.reset_score()
	get_tree().change_scene_to_packed(gameScene)
	
	
func _on_button_quit_pressed():
	get_tree().quit()
