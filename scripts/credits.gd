extends CanvasLayer

var main_scene = "res://Scenes/mainMenu.tscn"

func _on_button_main_pressed():
	get_tree().change_scene_to_file(main_scene)
