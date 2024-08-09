extends CanvasLayer

var winScreenPanel
var winScreenText

func _ready():
	winScreenPanel = $PanelContainer
	winScreenText = $PanelContainer/GridContainer/Label
	winScreenText.text = GameStateManager.currentVictorString + " wins by: " + GameStateManager.currentVictoryReasonString
