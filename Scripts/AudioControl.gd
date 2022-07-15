extends Control

onready var master_slider = $ScrollContainer/VBoxContainer/MasterVolume/MasterHSlider
onready var music_slider = $ScrollContainer/VBoxContainer/MusicVolume/MusicHSlider
onready var effects_slider = $ScrollContainer/VBoxContainer/EffectsVolume/EffectsHSlider

func _on_MasterHSlider_value_changed(value):
	Global.change_volume(Global.Bus.Master, value)
	$TickSoundAudioStream.play()
	

func _on_MusicHSlider_value_changed(value):
	Global.change_volume(Global.Bus.Music, value)
	$TickSoundAudioStream.play()


func _on_EffectsHSlider_value_changed(value):
	Global.change_volume(Global.Bus.Effects, value)
	$TickSoundAudioStream.play()

func update_sliders():
	master_slider.value = Global.volumes[Global.Bus.Master]
	music_slider.value = Global.volumes[Global.Bus.Music]
	effects_slider.value = Global.volumes[Global.Bus.Effects]

func _on_Audio_draw():
	update_sliders()

