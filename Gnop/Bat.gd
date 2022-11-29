extends RigidBody2D


var walking_up: bool = true
export var id: String = ""
export var speed: int = 10
export var disable_left_border = false
export var disable_right_border = false
var start_speed = speed

const TOP_BOUND = 100
const BOTTOM_BOUND = 500
const MIN_SPEED: int = 1
const MAX_SPEED: int = 15
const LINEAR_INCREASE := 0
const LINEAR_DECREASE := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	start_speed = speed
	
	_randomify_walk_dir()
	
	$LeftBorder.set_disabled(disable_left_border)
	$RightBorder.set_disabled(disable_right_border)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (walking_up):
		position.y -= speed
		if (position.y < TOP_BOUND):
			walking_up = false
	elif (!walking_up):
		position.y += speed
		if (position.y > BOTTOM_BOUND):
			walking_up = true


func get_id() -> String:
	return id
	

func blink():
	$AnimatedSprite.play("default")
	$AnimatedSprite.set_frame(0)
	


func _randomify_walk_dir():
	var walking_dir := randi() % 2
	if walking_dir == 0:
		walking_up = false
	elif walking_dir == 1:
		walking_up = true


func _choose_next_movement():
	pass


func _linear_speed_increase(increase_amount: int):
	if speed + increase_amount > MAX_SPEED:
		speed = MAX_SPEED
	else:
		speed += increase_amount


func _linear_speed_decrease(decrease_amount: int):
	if speed - decrease_amount < MIN_SPEED:
		speed = MIN_SPEED
	else:
		speed -= decrease_amount


func _on_MovementTimer_timeout():
	print("Bat with ID: " + id + " waited for 5 secs.")
	var move_update_method: int = randi() % 2  # 0 or 1
	var change_amount := randi() % 5  # 0, 1, 2, 3 or 4
	
	if move_update_method == LINEAR_INCREASE:
		print("\tchoosing linear increase (" + str(change_amount) + ")")
		_linear_speed_increase(change_amount)
	elif move_update_method == LINEAR_DECREASE:
		print("\tchoosing linear decrease (" + str(change_amount) + ")")
		_linear_speed_decrease(change_amount)
	print("\tSpeed now: " + str(speed))
	print()
