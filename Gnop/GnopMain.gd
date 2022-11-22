extends Node2D

export (PackedScene) var powerup_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	# disable left collision segment for left bat and right segment for right bat
	# otherwise it can get stuck between them
	$BatLeft.get_node("LeftBorder").set_deferred("disabled", true)
	$BatRight.get_node("RightBorder").set_deferred("disabled", true)
	
	GlobalVariables.points = 0
	$AudioPlayer.play()
	
	_start_powerup_timer()


func _process(delta):
	$PointLabel.text = str(GlobalVariables.points)


func _on_OutZone_body_entered(body: Node):
	if body.is_in_group("ball"):
		print("Game Over")
		$BatLeft.hide()
		$BatRight.hide()
		$Ball.explode()
		$GameOverHUD.activate()


func _start_powerup_timer():
	var duration = randi() % 3 + 4
	$PowerUpTimer.start(duration)
	print("powerup timer started with ", duration, " seconds")


func _on_PowerUpTimer_timeout():
	# TODO make better random position
	var powerup = powerup_scene.instance()
	var y = randi() % 200 + 200
	var x = randi() % 600 + 200
	powerup.position = Vector2(x, y)
	add_child(powerup)
	_start_powerup_timer()
