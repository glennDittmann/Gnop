extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$BackButton.grab_focus()


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		$UIAudio.play()


func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu.tscn")
