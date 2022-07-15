extends Button


var hovered = false

func _ready():
	$ButtonTexture/Label.text = text
	text = ""

func _on_Button_mouse_entered():
	$AnimationPlayer.play("hover")
	if Global.color_mode:
		$ButtonTexture.modulate = Global.current_color

func _on_Button_mouse_exited():
	$AnimationPlayer.stop()
	$ButtonTexture.rect_position.y = 0
	$ButtonTexture.modulate = Color(1,1,1)
	modulate = Color(1,1,1)

func _on_Button_button_down():
	$ButtonTexture.rect_position.y = 0
	$ButtonTexture.modulate = Color(1,1,1)
	$ClickSoundAudioStream.play()
	$AnimationPlayer.play("pressed")


func _on_Button_button_up():
	$AnimationPlayer.play("released")
	
