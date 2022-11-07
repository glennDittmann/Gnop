extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	print('Pressing start button')
	get_tree().change_scene("res://Placeholder.tscn")


func _on_OptionsButton_pressed():
	print('Pressing options button')
	get_tree().change_scene("res://Placeholder.tscn")
	#var options = load('res://scene_path.tscn').instance()
	#get_tree().current_scene.add_child(options)


func _on_QuitButton_pressed():
	get_tree().quit()
