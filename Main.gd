extends Node2D

var particle_resource = load("res://Components/Particles.tscn")

onready var ui_scores_value = $CanvasLayer/Control/Scores/Value
onready var ui_lines_value = $CanvasLayer/Control/Lines/Value
onready var ui_level_value = $CanvasLayer/Control/Level/Value

var scores = 0
var lines = 0
var level = 0
var old_level = 0
var colors = [
	Color(1, 0.683594, 0.683594),
	Color(1, 0.868988, 0.683594),
	Color(1, 0.980225, 0.683594),
	Color(0.683594, 1, 0.695953),
	Color(0.683594, 1, 0.80719),
	Color(0.683594, 1, 0.925842),
	Color(0.683594, 0.911011, 1),
	Color(0.683594, 0.695953, 1),
	Color(1, 0.683594, 0.995056)
]
var level_color = Color(1,1,1)

func _ready():
	randomize()
	$CanvasLayer/Control/PauseLabel.visible = false
	$Timer.start()


func _on_ActiveFigure_block_placed():
	$AnimationPlayer.play("block_placed")
	
func _on_ActiveFigure_blocks_sweeped(sweeped_rows):
	update_stats(sweeped_rows)
	
	for row in sweeped_rows:
		for x in range(len($GameBoard.Matrix.matrix[0])):
			var cell_size = $GameBoard.Matrix.cell_size
			var particle = particle_resource.instance()
			particle.start_emitting()
			particle.position = $GameBoard.position + Vector2(x*cell_size, row*cell_size)
			add_child(particle)
	$AnimationPlayer.play("sweeped" + str(len(sweeped_rows)))

func _on_ActiveFigure_reset():
	update_stats()

func update_stats(sweeped_rows = []):
	if len(sweeped_rows) < 1:
		scores = 0
		lines = 0
		level = 0
	else:
		scores += int(pow(4, len(sweeped_rows)) + 50)
		lines += int(len(sweeped_rows))
		level = int(scores/300)
	
	set_ui_value(ui_scores_value, str(scores))
	set_ui_value(ui_lines_value, str(lines))
	$CanvasLayer/AnimationPlayer.play("scores&lines_changed")
	if level > old_level:
		set_ui_value(ui_level_value, str(level))
		$CanvasLayer/AnimationPlayer.play("level_changed")
		old_level = level
		level_color = colors[level%len(colors)]
		set_color_theme()
	elif len(sweeped_rows) < 1:
		level_color = Color(1,1,1)
		set_color_theme()
		set_ui_value(ui_level_value, str(level))
		$CanvasLayer/AnimationPlayer.play("level_changed")
		old_level = 0

func set_color_theme():
	$Background.modulate = level_color
	$Foreground.modulate = level_color
	$CanvasLayer/Control.modulate = level_color
	
func set_ui_value(ui_component, value):
	var ui_value = "" 
	for _i in range(clamp(len(ui_component.text) - len(value), 0, 6)):
		ui_value += "0"
	ui_component.text = ui_value + value

func change_pause_state():
	$Timer.paused = !$Timer.paused
	$CanvasLayer/Control/PauseLabel.visible = $Timer.paused
		

func _on_PauseButton_pressed():
	change_pause_state()
