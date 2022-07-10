extends Node2D

class_name Block

var textures = [
	load("res://Sprites/texture_type1.tres"),
	load("res://Sprites/texture_type2.tres"),
	load("res://Sprites/texture_type3.tres"),
	load("res://Sprites/texture_type4.tres"),
]


var type = 0
	
func copy(block):
	set_texture(block.type, block.modulate)

func animate_creation():
	$AnimationPlayer.play("created")

func set_texture(_type, color = Color(1,1,1,1)):
	type = _type
	modulate = color
	$Sprite.texture = textures[type]

func delete():
	$AnimationPlayer.play("fade_out")
	

