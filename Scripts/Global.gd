extends Node
signal freeing_orphans

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

var seconds_amount = 0
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

func free_orphaned_nodes():
	emit_signal("freeing_orphans")
