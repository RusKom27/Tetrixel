extends Control

enum State {
	MenuButtons,
	SettingsButtons,
	Audio,
	Graphics,
	Gameplay,
	About
}

var current_state = State.MenuButtons
var animation_player : AnimationPlayer = null
var foreground : Sprite = null
var opened_foreground : Sprite = null

func _on_StartButton_pressed():
	animation_player.play("exit_from_menu")
	
func exit_from_menu(to_game := true):
	if to_game:
		Global.current_color = Color(1,1,1)
		get_tree().change_scene("res://Scenes/Main.tscn")
	else:
		get_tree().quit()

func _on_SettingsButton_pressed():
	current_state = State.SettingsButtons
	animation_player.play("fade_in")

func _on_AboutButton_pressed():
	current_state = State.About
	animation_player.play("fade_in")

func _on_BackAboutButton_pressed():
	current_state = State.MenuButtons
	animation_player.play("fade_in")

func _on_BackButton_pressed():
	current_state = State.MenuButtons
	animation_player.play("fade_in")

func _on_AudioButton_pressed():
	current_state = State.Audio
	animation_player.play("fade_in")

func _on_GraphicsButton_pressed():
	current_state = State.Graphics
	animation_player.play("fade_in")

func _on_GameplayButton_pressed():
	current_state = State.Gameplay
	animation_player.play("fade_in")

func apply_state():
	for child in get_children():
		child.visible = child.name == State.keys()[current_state]

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_in":
		animation_player.play("fade_out")

func _on_ApplyAudioButton_pressed():
	current_state = State.SettingsButtons
	animation_player.play("fade_in")


func _on_ApplyGraphicsButton_pressed():
	current_state = State.SettingsButtons
	animation_player.play("fade_in")


func _on_ApplyGameplayeButton_pressed():
	current_state = State.SettingsButtons
	animation_player.play("fade_in")


func _on_ExitButton_pressed():
	get_tree().quit()

