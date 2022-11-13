extends KinematicBody2D

var speed := 200
var n_hits: int = 0
var move_dir := Vector2()   # implicitly typed variable 

# Called when the node enters the scene tree for the first time.
func _ready():
	move_dir = Vector2.RIGHT * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().change_scene("res://Menu.tscn")
		

func _physics_process(delta):
	# kinematic body intro: https://docs.godotengine.org/en/3.5/tutorials/physics/using_kinematic_body_2d.html
	if(Input.is_action_pressed("move_up")):
		move_dir = Vector2(move_dir.x/speed, -1)*speed
	elif(Input.is_action_pressed("move_down")):
		move_dir = Vector2(move_dir.x/speed, 1)*speed
	else:
		if move_dir.x > 0:
			move_dir.x = speed
		else:
			move_dir.x = -speed
		move_dir.y = 0
	
	var collision: KinematicCollision2D = move_and_collide(move_dir * delta)
	_handle_collision(collision)


func _handle_collision(collision: KinematicCollision2D):
	if collision:
		if collision.collider.is_in_group("bats"):
			print("Ball collided with ", collision.collider.name, "  Speed: ", speed)
			n_hits += 1
			speed += n_hits * 5
			move_dir = move_dir.bounce(collision.normal)
		elif collision.collider.is_in_group("game_over_zone"):
			get_tree().change_scene("res://Menu.tscn")
