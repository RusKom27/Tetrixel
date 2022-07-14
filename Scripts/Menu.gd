extends Node

onready var active_background = $ActiveBackground

func _ready():
	randomize()
	Global.current_color = Global.colors[randi()%len(Global.colors)]
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

func _on_StartButton_pressed():
	Global.current_color = Color(1,1,1)
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_SettingsButton_pressed():
	pass # Replace with function body.
