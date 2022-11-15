extends KinematicBody2D

var speed := 200

var turn_speed_factor := 0.0003
var ANGLE_THRESHOLD = PI / 3

var n_hits: int = 0
var move_dir := Vector2()   # implicitly typed variable 

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
				
	var collision: KinematicCollision2D = move_and_collide(move_dir * delta)
	_handle_collision(collision)


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
			speed += n_hits * 5
			move_dir = move_dir.bounce(collision.normal)
		if collision.collider.is_in_group("borders"):	
			move_dir = move_dir.bounce(collision.normal)
		elif collision.collider.is_in_group("game_over_zone"):
			get_tree().change_scene("res://Menu.tscn")
