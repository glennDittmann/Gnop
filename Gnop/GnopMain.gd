extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# disable left collision segment for left bat and right segment for right bat
	# otherwise it can get stuck between them
	$BatLeft.get_node("LeftBorder").set_deferred("disabled", true)
	$BatRight.get_node("RightBorder").set_deferred("disabled", true)
	
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
		$GameOverHUD.activate()
