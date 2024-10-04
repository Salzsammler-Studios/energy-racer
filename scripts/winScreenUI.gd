extends CanvasLayer
@onready var winScreenLabel = $PanelContainer/GridContainer/Label
@onready var playAgainButton = $PanelContainer/GridContainer/ResetButton
var gameScene = preload("res://Scenes/world.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	winScreenLabel.text = Score.winner+' HAT GEWONNEN'

func _on_reset_button_pressed():
	Score.reset_score()
	get_tree().change_scene_to_packed(gameScene)
