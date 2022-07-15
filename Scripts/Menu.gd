extends Node

onready var active_background = $ActiveBackground

func _ready():
	randomize()
	$ThemeMusicAudioStream.play()
	$CanvasLayer/Control.animation_player = $AnimationPlayer
	$CanvasLayer/Control.foreground = $Foreground
	$CanvasLayer/Control.opened_foreground = $OpenedForeground
	$AnimationPlayer.play("fade_in")
	update_colors()
	Global.update_volume()

func update_colors():
	if Global.color_mode:
		Global.current_color = Global.colors[randi()%len(Global.colors)]
	else:
		Global.current_color = Color(1,1,1)
	$PassiveBackground.modulate = Global.current_color
	$Title.modulate = Global.current_color
	active_background.modulate = Global.current_color

func _process(delta):
	move_active_background(delta)

func move_active_background(delta):
	for child in active_background.get_children():
		child.position += Vector2(0,4*delta).normalized() - Vector2(0,0.7)
		if child.position.y > 360:
			child.position.y = -536

func _on_ApplyGameplayeButton_pressed():
	Global.save_settings()

func _on_ApplyGraphicsButton_pressed():
	Global.save_settings()

func _on_ApplyAudioButton_pressed():
	Global.save_settings()
