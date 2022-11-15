extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioPlayer.play()
	pass # Replace with function body.


func _process(delta):
	$PointLabel.text = str(GlobalVariables.points)


func _on_OutZone_body_entered(body: Node):
	if body.is_in_group("ball"):
		print("Game Over")
		get_tree().change_scene("res://Menu.tscn")  # change for game over screen
