extends Node

onready var active_background = $ActiveBackground

func _ready():
	randomize()
	var rand_color = Global.colors[randi()%len(Global.colors)]
	$PassiveBackground.modulate = rand_color
	active_background.modulate = rand_color

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")
	
func _process(delta):
	move_active_background(delta)

func move_active_background(delta):
	for child in active_background.get_children():
		child.position += Vector2(0,4*delta).normalized() - Vector2(0,0.7)
		if child.position.y > 360:
			child.position.y = -536
	
