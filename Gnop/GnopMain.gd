extends Node2D

export (PackedScene) var powerup_scene

const POWERUP_INCREASE_RATE = 0.5
var slowdown_bar_increase_amount

var powerup: Area2D

var screen_size

var _high_score_save: HighScoreSave

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_or_load_save()
	randomize()
	screen_size = $Court.get_viewport_rect().size
	#print("screen_size: ", screen_size)
	slowdown_bar_increase_amount = $SlowDownBar.get_max() * POWERUP_INCREASE_RATE
	
	GlobalVariables.points = 0
	$AudioPlayer.play()
	
	_start_powerup_timer()


func _process(delta):
	$PointLabel.text = str(GlobalVariables.points)


func _create_or_load_save() -> void:
	if HighScoreSave.save_exists():
		_high_score_save = HighScoreSave.load_highscore_save() as HighScoreSave
	else:
		_high_score_save = HighScoreSave.new()
		_high_score_save.high_score = 0
		_high_score_save.second_score = 0
		_high_score_save.third_score = 0
		_high_score_save.write_highscore()

	GlobalVariables.high_score = _high_score_save.high_score
	GlobalVariables.second_score = _high_score_save.second_score
	GlobalVariables.third_score = _high_score_save.third_score


func _on_OutZone_body_entered(body: Node):
	if body.is_in_group("ball"):
		_high_score_save.check_and_update_score(GlobalVariables.points)
		GlobalVariables.high_score = _high_score_save.high_score
		GlobalVariables.second_score = _high_score_save.second_score
		GlobalVariables.third_score = _high_score_save.third_score
		_high_score_save.write_highscore()
		$Ball.explode()
		#get_tree().change_scene("res://GameOverHUD.tscn")


func _start_powerup_timer():
	var duration = randi() % 3 + 4
	$PowerUpTimer.start(duration)
	#print("powerup timer started with ", duration, " seconds")


func _on_PowerUpTimer_timeout():
	# get random position on field with some margin
	var horizontal_margin = 200
	var vertical_margin = 20
	var x = randi() % int(screen_size.x - 2 * horizontal_margin) + horizontal_margin
	var y = randi() % int(screen_size.y - 2 * vertical_margin) + vertical_margin
	# create powerup
	powerup = powerup_scene.instance()
	powerup.position = Vector2(x, y)
	add_child(powerup)
	# connect to hit signal of the powerup
	powerup.connect("powerup_hit", self, "on_powerup_hit")


func on_powerup_hit():
	# increase slowdown bar and restart power up timer
	$PowerupConsumeSound.play()
	var new_val = $SlowDownBar.get_value() + slowdown_bar_increase_amount
	$SlowDownBar.set_value(new_val)
	_start_powerup_timer()


func _on_Ball_visibility_changed():
	# in _on_OutZone_body_entered(), i.e. game over, Ball.explode() gets called
	# which plays the explode animation and then hides the ball
	# thus we can then change to the game over screen
	if not $Ball.visible:
		get_tree().change_scene("res://GameOverHUD.tscn")
