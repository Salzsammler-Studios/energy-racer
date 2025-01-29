extends CanvasLayer

var main_scene = preload("res://Scenes/mainMenu.tscn")

func _on_button_main_pressed():
	get_tree().change_scene_to_packed(main_scene)
