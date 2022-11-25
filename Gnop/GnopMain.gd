extends Node2D

export (PackedScene) var powerup_scene

const POWERUP_INCREASE_RATE = 0.5
var slowdown_bar_increase_amount

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screen_size = $Court.get_viewport_rect().size
	print("screen_size: ", screen_size)
	slowdown_bar_increase_amount = $SlowdownBar.get_max() * POWERUP_INCREASE_RATE
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
		$PowerUpTimer.stop()


func _start_powerup_timer():
	var duration = randi() % 3 + 4
	$PowerUpTimer.start(duration)
	print("powerup timer started with ", duration, " seconds")


func _on_PowerUpTimer_timeout():
	# get random position on field with some margin
	var horizontal_margin = 200
	var vertical_margin = 20
	var x = randi() % int(screen_size.x - 2 * horizontal_margin) + horizontal_margin
	var y = randi() % int(screen_size.y - 2 * vertical_margin) + vertical_margin
	# create powerup
	var powerup = powerup_scene.instance()
	powerup.position = Vector2(x, y)
	add_child(powerup)
	# connect to hit signal of the powerup
	powerup.connect("powerup_hit", self, "on_powerup_hit")

func on_powerup_hit():
	# increase slowdown bar and restart power up timer
	var new_val = $SlowdownBar.get_value() + slowdown_bar_increase_amount
	$SlowdownBar.set_value(new_val)
	_start_powerup_timer()
