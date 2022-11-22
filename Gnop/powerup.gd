extends Area2D

signal powerup_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Powerup_body_entered(body):
	# TODO handle collision
	emit_signal("powerup_hit")
	print("powerup hit")
	pass # Replace with function body.
