extends Node2D

var matrix_resource = load("res://Scripts/Matrix.gd")
var block_resource = load("res://Components/Block.tscn")

var Matrix = null
var initial_position = null

func _ready():
	initial_position = position
	Matrix = matrix_resource.new()
	
	
func draw_matrix():
	position = initial_position + Vector2((4 - len(Matrix.matrix)) * 8, (4 - len(Matrix.matrix[0])) * 8)
	for n in get_children():
		remove_child(n)
	for y in range(len(Matrix.matrix)):
		for x in range(len(Matrix.matrix[y])):
			if Matrix.matrix[y][x] != null:
				Matrix.matrix[y][x].position = Vector2(x * Matrix.cell_size, y * Matrix.cell_size)
				add_child(Matrix.matrix[y][x])
