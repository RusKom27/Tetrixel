extends Node2D


func _ready():
	randomize()
	$Timer.start()


func _on_ActiveFigure_block_placed():
	$AnimationPlayer.play("block_placed")


func _on_ActiveFigure_blocks_sweeped(sweeped_rows):
	print("sweeped" + str(sweeped_rows))
	$AnimationPlayer.play("sweeped" + str(sweeped_rows))
