extends CanvasLayer


var game_scene = preload("res://Scenes/world.tscn")
var credit_scene = preload("res://Scenes/credits.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_start_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_button_credits_pressed():
	get_tree().change_scene_to_packed(credit_scene)


func _on_button_quit_pressed():
	get_tree().quit()
