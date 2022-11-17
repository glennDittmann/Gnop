extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.points = 0
	$AudioPlayer.play()


func _process(delta):
	$PointLabel.text = str(GlobalVariables.points)


func _on_OutZone_body_entered(body: Node):
	if body.is_in_group("ball"):
		print("Game Over")
		$BatLeft.hide()
		$BatRight.hide()
		$Ball.explode()
		$GameOverHUD.show()
