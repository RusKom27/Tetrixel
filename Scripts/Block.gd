extends Node2D

class_name Block

var type = 0
	
func _init():
	Global.connect("freeing_orphans", self, "_free_if_orphaned")

	
func copy(block):
	set_texture(block.type, block.modulate)

func animate_creation():
	$AudioStreamPlayer.play()
	
	$CPUParticles2D.start_emitting()
	$AnimationPlayer.play("created")

func set_texture(_type, color = Color(1,1,1,1)):
	type = _type
	modulate = color
	$Sprite.texture = Global.block_textures[type]
	
func _free_if_orphaned():
	if not is_inside_tree():
		queue_free()
