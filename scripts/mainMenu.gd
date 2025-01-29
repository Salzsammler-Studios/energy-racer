extends CanvasLayer


var game_scene = preload("res://Scenes/world.tscn")
var credit_scene = preload("res://Scenes/credits.tscn")


func _on_button_start_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_button_credits_pressed():
	get_tree().change_scene_to_packed(credit_scene)


func _on_button_quit_pressed():
	get_tree().quit()
