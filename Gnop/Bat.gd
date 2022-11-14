extends RigidBody2D


var walking_up: bool = true
export var speed: int = 10

const TOP_BOUND = 100
const BOTTOM_BOUND = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
