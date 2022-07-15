extends Control

onready var fps_limit_slider = $ScrollContainer/VBoxContainer/FPSLimit/FPSLimitHSlider
onready var fps_display = $ScrollContainer/VBoxContainer/FPSLimit/FPS
onready var particles_checkbox = $ScrollContainer/VBoxContainer/Particles/ParticlesCheckBox
onready var color_mode_checkbox = $ScrollContainer/VBoxContainer/ColorMode/ColorModeCheckBox

func _ready():
	fps_limit_slider.value = Engine.get_target_fps()
	particles_checkbox.pressed = Global.particles
	color_mode_checkbox.pressed = Global.color_mode

func _on_FPSLimitHSlider_value_changed(value):
	Global.framerate = value
	Engine.set_target_fps(Global.framerate)
	fps_display.text = str(Global.framerate)
	
func _on_ColorModeCheckBox_pressed():
	Global.color_mode = !Global.color_mode
	get_tree().root.get_node("Node2D").update_colors()

func _on_ParticlesCheckBox_pressed():
	Global.particles = !Global.particles
