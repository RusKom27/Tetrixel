extends Node2D


var Matrix = null
var matrix_resource = load("res://Scripts/Matrix.gd")
var block_resource = load("res://Components/Block.tscn")

func _ready():
	Matrix = matrix_resource.new()
	Matrix.create_matrix(10, 21)
	draw_matrix()

func draw_matrix():
	for n in get_children():
		remove_child(n)
	for y in range(len(Matrix.matrix)):
		for x in range(len(Matrix.matrix[y])):
			if Matrix.matrix[y][x] != null:
				Matrix.matrix[y][x].position = Vector2(x * Matrix.cell_size, y * Matrix.cell_size)
				add_child(Matrix.matrix[y][x])
	Matrix.print_matrix()
