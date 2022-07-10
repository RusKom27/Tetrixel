extends Node2D


var cell_original = load("res://Components/EmptyCell.tscn").instance()

var matrix_resource = load("res://Scripts/Matrix.gd")
var block_resource = load("res://Components/Block.tscn")

var Matrix = null

func _ready():
	Matrix = matrix_resource.new()
	
	
func draw_matrix():
	for n in get_children():
		remove_child(n)
	for y in range(len(Matrix.matrix)):
		for x in range(len(Matrix.matrix[y])):
			if Matrix.matrix[y][x] != null:
				Matrix.matrix[y][x].position = Vector2(x * Matrix.cell_size, y * Matrix.cell_size)
				add_child(Matrix.matrix[y][x])
