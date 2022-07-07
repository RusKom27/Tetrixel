extends Node2D

var width = 4
var height = 4
var matrix = []
var cell_original = load("res://Components/EmptyCell.tscn").instance()


func _ready():
	for y in range(height):
		matrix.append([])
		for x in range(width):
			var cell = cell_original.duplicate()
			cell.position = Vector2(x*16,y*16)
			matrix[y].append(cell)
			add_child(cell)
