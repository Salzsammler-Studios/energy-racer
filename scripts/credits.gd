extends CanvasLayer

var main_scene = "res://Scenes/mainMenu.tscn"
@onready var button_main = $Control/Control/VBoxContainer/ButtonMain

func _on_button_main_pressed():
	get_tree().change_scene_to_file(main_scene)

func _ready():
	button_main.grab_focus()
