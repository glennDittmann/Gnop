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

# Called when the node enters the scene tree for the first time.
func _ready():
	move_dir = Vector2.RIGHT * speed
	print("RIGHT with x axis ", Vector2.RIGHT.angle())
	print("RIGHT+30° with x axis ", rad2deg(Vector2.RIGHT.rotated(PI/6).angle()))
	print("RIGHT-30° with x axis ", rad2deg(Vector2.RIGHT.rotated(-PI/6).angle()))
	print("LEFT with leftx axis ", rad2deg(Vector2.LEFT.angle_to(Vector2.LEFT)))
	print("LEFT+30° with left x axis ", rad2deg(Vector2.LEFT.rotated(PI/6).angle_to(Vector2.LEFT)))
	print("LEFT-30° with left x axis ", rad2deg(Vector2.LEFT.rotated(-PI/6).angle_to(Vector2.LEFT)))

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
		_slow_down()
	if(Input.is_action_just_released("ui_select")):
		_slow_up()
				
	var collision: KinematicCollision2D = move_and_collide(move_dir * delta)
	if not exploded:
		_handle_collision(collision)


func _slow_down():
	# slow down ball
	move_dir = move_dir.normalized() * (speed / 2)
	# slow down bats
	var bat_left = get_node("../BatLeft")
	var bat_right = get_node("../BatRight")
	for bat in [bat_left, bat_right]:
		var current_speed = bat.get("start_speed")
		bat.set_deferred("speed", current_speed / 1)


func _slow_up():
	# revert slow down of ball and bats
	move_dir = move_dir.normalized() * speed
	var bat_left = get_node("../BatLeft")
	var bat_right = get_node("../BatRight")
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
		print("Ball collided with ", collision.collider.name, "  Speed: ", speed)
		if collision.collider.is_in_group("bats"):
			n_hits += 1
			
			_add_points(collision.collider)
			
			speed = _get_speed(n_hits)
			move_dir = move_dir.bounce(collision.normal)
			# apply new speed after bounce
			move_dir = move_dir.normalized() * speed
		if collision.collider.is_in_group("borders"):	
			move_dir = move_dir.bounce(collision.normal)


func _add_points(collider: RigidBody2D):
	if last_bat_hit != collider.get_id():  # hitting a new / the other bat
		GlobalVariables.points += 1
		$Audio.play()
		last_bat_hit = collider.get_id()

func explode():
	move_dir = Vector2.ZERO
	exploded = true
	$AnimatedSprite.play("explode")
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
