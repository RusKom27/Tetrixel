extends Node2D

onready var ui_scores_value = $CanvasLayer/Control/Scores/Value
onready var ui_lines_value = $CanvasLayer/Control/Lines/Value
onready var ui_level_value = $CanvasLayer/Control/Level/Value

var seconds_amount = 0
var scores = 0
var lines = 0
var level = 0
var old_level = 0

var level_color = Color(1,1,1)

func _ready():
	$CanvasLayer/Control/PauseLabel.visible = false
	$ThemeMusicAudioStream.play()
	$Timer.start()

func _on_ActiveFigure_figure_moved():
	$TickSoundAudioStream.play()

func _on_ActiveFigure_block_placed():
	$AnimationPlayer.play("block_placed")
	
func _on_ActiveFigure_blocks_sweeped(sweeped_rows):
	update_stats(sweeped_rows)
	$SwipeSoundAudioStream.play()
	$AnimationPlayer.play("sweeped" + str(len(sweeped_rows)))


func _on_ActiveFigure_reset():
	update_stats()

func update_stats(sweeped_rows = []):
	if len(sweeped_rows) < 1:
		scores = 0
		lines = 0
		level = 0
		seconds_amount = 0
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
		level_color = Global.colors[level%len(Global.colors)]
		set_level_theme()
	elif len(sweeped_rows) < 1:
		level_color = Color(1,1,1)
		set_level_theme()
		set_ui_value(ui_level_value, str(level))
		$CanvasLayer/AnimationPlayer.play("level_changed")
		old_level = 0

func set_level_theme():
	$LevelChangeSoundAudioStream.play()
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
	$ThemeMusicAudioStream.stream_paused = $Timer.paused
	$CanvasLayer/Control/PauseLabel.visible = $Timer.paused
		

func _on_PauseButton_pressed():
	$ClickSoundAudioStream.play()
	change_pause_state()


func _on_MenuButton_pressed():
	$ClickSoundAudioStream.play()
	get_tree().change_scene("res://Scenes/Menu.tscn")

func _on_RestartButton_pressed():
	$ClickSoundAudioStream.play()
	restart()

func restart():
	update_stats()
	$ActiveFigure.reset(true)

func _on_Timer_timeout():
	Global.free_orphaned_nodes()
	randomize()
	seconds_amount += $Timer.wait_time
	var seconds = str(int(int(seconds_amount)%60))
	var minutes = str(int(int(seconds_amount / 60)%60))
	var hours = str(int(int(seconds_amount / 60 / 60)%60))
	if len(seconds) < 2:
		seconds = "0" + seconds
	if len(minutes) < 2:
		minutes = "0" + minutes
	if len(hours) < 2:
		hours = "0" + hours
	$CanvasLayer/Control/TimeAmount.text = hours + ":" + minutes + ":" + seconds




