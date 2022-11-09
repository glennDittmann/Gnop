extends KinematicBody2D

var speed: int = 5              # typed variable
var move_dir := Vector2(3, 0)   # implicitly typed variable 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("move_up")):
		position.y -= speed
	elif(Input.is_action_pressed("move_down")):
		position.y += speed
	elif(Input.is_action_just_pressed("ui_cancel")):
		get_tree().change_scene("res://Menu.tscn")
		

func _physics_process(delta):
	position.x += move_dir.x
	pass
