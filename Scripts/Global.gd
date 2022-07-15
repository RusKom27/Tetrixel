extends Node
signal freeing_orphans

var settings = preload("res://settings.tres")

onready var particle_resource = load("res://Components/Particles.tscn")
onready var matrix_resource = load("res://Scripts/Matrix.gd")
onready var block_resource = load("res://Components/Block.tscn")

var block_place_sound = load("res://Sounds/hit1.tres")
var timer_tick_sound = load("res://Sounds/tick1.wav")

var block_textures = [
	load("res://Sprites/texture_type1.tres"),
	load("res://Sprites/texture_type2.tres"),
	load("res://Sprites/texture_type3.tres"),
	load("res://Sprites/texture_type4.tres"),
]

enum Bus {
	Master,
	Music,
	Effects
}

var framerate = 60
var color_mode = true
var particles = true
var cell_size = 16

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

var current_color = Color(1,1,1)


var volumes = {
	Bus.Master: 100,
	Bus.Music: 50,
	Bus.Effects: 50
}

func load_settings():
	var settings = load("res://settings.tres")
	framerate = settings.framerate
	color_mode = settings.color_mode
	particles = settings.particles
	volumes = settings.volumes

func save_settings():
	var settings = Settings.new()
	settings.framerate = framerate
	settings.color_mode = color_mode
	settings.particles = particles
	settings.volumes = volumes
	ResourceSaver.save("res://settings.tres", settings)

func _ready():
	load_settings()
	update_volume()
	Engine.set_target_fps(framerate)
		
func update_volume():
	for bus in Bus.values():
		change_volume(bus, volumes[bus])

func change_volume(bus, value):
	var db = lerp(-50, 6, value/100)
	AudioServer.set_bus_volume_db(bus, db)
	AudioServer.set_bus_mute(bus, db == -50)
	volumes[bus] = value

func free_orphaned_nodes():
	emit_signal("freeing_orphans")
