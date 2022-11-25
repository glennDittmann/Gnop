extends RigidBody2D


var walking_up: bool = true
export var id: String = ""
export var speed: int = 10
export var disable_left_border = false
export var disable_right_border = false
var start_speed = speed

const TOP_BOUND = 100
const BOTTOM_BOUND = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	start_speed = speed
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
	
