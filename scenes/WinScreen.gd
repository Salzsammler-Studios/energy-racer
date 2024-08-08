extends CanvasLayer

var WinScreenPanel

func _ready():
	WinScreenPanel = $PanelContainer
	WinScreenPanel.visible = false

func check_for_win():
	# Replace this condition with the actual win condition.
	var someone_won = true 
	
	if someone_won:
		toggle_WinScreen()

func toggle_WinScreen():
	WinScreenPanel.visible = !WinScreenPanel.visible
