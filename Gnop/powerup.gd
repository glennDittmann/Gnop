extends Area2D

signal powerup_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Powerup_body_entered(body):
	hide()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("powerup_hit")
	queue_free()
