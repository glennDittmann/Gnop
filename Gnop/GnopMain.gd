extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OutZone_body_entered(body: Node):
	if body.is_in_group("ball"):
		print("Game Over")
		get_tree().change_scene("res://Menu.tscn")  # change for game over screen
