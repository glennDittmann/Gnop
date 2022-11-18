extends Control


var ui_up_down_path: String = "res://assets/key.ogg"
var ui_accept_path: String = "res://assets/swhit.ogg"

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/RetryButton.grab_focus()
	
	var sfx_ui_up_down: Resource = load(ui_up_down_path)
	$UIAudio.stream = sfx_ui_up_down


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseMotion:
		$VBoxContainer/RetryButton.release_focus()
		$VBoxContainer/BackButton.release_focus()
	elif (
		(Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up")) 
		and no_button_has_focus()
	):
		$VBoxContainer/BackButton.grab_focus()
		
	if(Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up")):
		$UIAudio.play()
	elif Input.is_action_just_pressed("ui_accept"):
		var sfx_accept: Resource = load(ui_accept_path)
		$UIAudio.stream = sfx_accept
		$UIAudio.play()


func no_button_has_focus() -> bool: 
	return (
		not $VBoxContainer/RetryButton.has_focus() 
		and not $VBoxContainer/BackButton.has_focus()
	)


func _on_RetryButton_pressed():
	get_tree().change_scene("res://Gnop/GnopMain.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu.tscn")
	#var options = load('res://scene_path.tscn').instance()
	#get_tree().current_scene.add_child(options)