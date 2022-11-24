extends KinematicBody2D

const MAX_SPEED = 500.0
const START_SPEED = 200.0
var speed := START_SPEED

var turn_speed_factor := 0.0003
const ANGLE_THRESHOLD = PI / 3

var n_hits: int = 0
var move_dir := Vector2()   # implicitly typed variable 

var last_bat_hit: String = ""  # remember which bat was hit last time 
var exploded: bool = false

# some vars for easy access to nodes
var slowdown_bar: TextureProgress
var bat_left: RigidBody2D
var bat_right: RigidBody2D

const slow_factor = 2
const slowdown_bar_drain_speed = 25 # controls how fast slowdown bar drains

# Called when the node enters the scene tree for the first time.
func _ready():
	move_dir = Vector2.RIGHT * speed
	slowdown_bar = get_node("../SlowdownBar")
	bat_left = get_node("../BatLeft")
	bat_right = get_node("../BatRight")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().change_scene("res://Menu.tscn")
		

func _physics_process(delta):
	# kinematic body intro: https://docs.godotengine.org/en/3.5/tutorials/physics/using_kinematic_body_2d.html
	if(Input.is_action_pressed("move_up")):
		_handle_move_up()
	elif(Input.is_action_pressed("move_down")):
		_handle_move_down()
	if(Input.is_action_pressed("ui_select")):
		_slow_down(delta)
	if(Input.is_action_just_released("ui_select")):
		_slow_up()
				
	if not exploded:
		var collision: KinematicCollision2D = move_and_collide(move_dir * delta)
		_handle_collision(collision)


func _slow_down(delta):
	var cur_val = slowdown_bar.get_value()
	if cur_val > 0:
		# slow down ball
		move_dir = move_dir.normalized() * (speed / slow_factor)
		# slow down bats
		for bat in [bat_left, bat_right]:
			var current_speed = bat.get("start_speed")
			bat.set_deferred("speed", current_speed / slow_factor)
		slowdown_bar.set_value(cur_val - delta * slowdown_bar_drain_speed)
	else:
		_slow_up()


func _slow_up():
	# revert slow down of ball and bats
	move_dir = move_dir.normalized() * speed
	for bat in [bat_left, bat_right]:
		var start_speed = bat.get("start_speed")
		bat.set_deferred("speed", start_speed)
	

func _handle_move_up():
	var turn_speed = turn_speed_factor * speed
	if move_dir.x > 0:
		move_dir = move_dir.rotated(-turn_speed)
		if move_dir.angle() < -ANGLE_THRESHOLD:
			move_dir = Vector2.RIGHT.rotated(-ANGLE_THRESHOLD) * speed
	else:
		move_dir = move_dir.rotated(turn_speed)
		if move_dir.angle_to(Vector2.LEFT) < -ANGLE_THRESHOLD:
			move_dir = Vector2.LEFT.rotated(ANGLE_THRESHOLD) * speed


func _handle_move_down():
	var turn_speed = turn_speed_factor * speed
	if move_dir.x > 0:
		move_dir = move_dir.rotated(turn_speed)
		if move_dir.angle() > ANGLE_THRESHOLD:
			move_dir = Vector2.RIGHT.rotated(ANGLE_THRESHOLD) * speed
	else:
		move_dir = move_dir.rotated(-turn_speed)
		if move_dir.angle_to(Vector2.LEFT) > ANGLE_THRESHOLD:
			move_dir = Vector2.LEFT.rotated(-ANGLE_THRESHOLD) * speed


func _handle_collision(collision: KinematicCollision2D):
	if collision:
		if (collision.collider.is_in_group("bats")
			and last_bat_hit != collision.collider.get_id()
		):  # hitting a new / the other bat
			collision.collider.blink()
			print("Ball collided with ", collision.collider.name, "  Speed: ", speed)
			n_hits += 1
		
			_add_points(collision.collider)
			
			
			speed = _get_speed(n_hits)
			move_dir = move_dir.bounce(collision.normal)
			# apply new speed after bounce
			move_dir = move_dir.normalized() * speed
			
			last_bat_hit = collision.collider.get_id()
		elif collision.collider.is_in_group("borders"):	
			move_dir = move_dir.bounce(collision.normal)


func _add_points(collider: RigidBody2D):
		GlobalVariables.points += 1
		$Audio.play()
		last_bat_hit = collider.get_id()

func explode():
	move_dir = Vector2.ZERO
	exploded = true
	$AnimatedSprite.play("explode")
	
	var sfx_explode: Resource = load(GlobalVariables.explode_path)
	$Audio.stream = sfx_explode
	$Audio.play()
	
	yield($AnimatedSprite, "animation_finished")
	hide()

func _get_speed(x) -> float:
	# f(x):=-e^-(a*x+x_0)+max_speed
	# where x_0=ln(1/(max_speed-start_speed), 
	# s.t. f(0)=start_speed and f(infinity)=MAX_SPEED
	# a controls how fast the speed increases
	# thx wolfram: https://www.wolframalpha.com/input?key=&i=solve+-e%5E-%280%2By%29%2Bt%3Ds%2C+y
	# ist quasi eine an der x und y achse gespiegelte e funktion (vielleicht wär auch ne log möglich)
	var a: float = 0.1
	var x_0 := log(1.0/(MAX_SPEED-START_SPEED))
	var exponent: float = -(a*x + x_0)
	var y := -exp(exponent) + MAX_SPEED
	return y
