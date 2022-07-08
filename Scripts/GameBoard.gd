extends Node2D

var width = 10
var height = 21
var matrix = []
var resource_block = load("res://Components/Block.tscn")

func _ready():
	create_matrix()


func create_matrix():
	for y in range(height):
		matrix.append([])
		for _x in range(width):
			matrix[y].append(0)

func clear_matrix():
	for y in range(height):
		for x in range(width):
			matrix[y][x] = 0
	draw_matrix()

func matrix_sweep():
	print_matrix(matrix)
	for y in range(len(matrix)):
		var line_detected = true
		for x in range(len(matrix[y])):
			if matrix[y][x] == 0:
				line_detected = false
		if line_detected:
			clear_row(y)
	print_matrix(matrix)
	draw_matrix()
		
		
func clear_row(row):
	for x in range(len(matrix[row])):
		matrix[row][x] = 0

	var rows = range(row)
	rows.invert()
	for y in rows:
		var temp = matrix[y]
		matrix[y] = matrix[y+1]
		matrix[y+1] = temp

func fill_row(row):
	for y in range(row):
		for x in range(len(matrix[0])):
			matrix[len(matrix)-1-y][x] = 1
	draw_matrix()

func print_matrix(m):
	var line = ""
	for _x in range(len(m)):
		line += "_"
	print(line)
	for y in range(len(m)):
		var row = ""
		for x in range(len(m[y])):
			row += str(m[y][x]) + "|"
		print(row)

func draw_matrix():
	for n in get_children():
		remove_child(n)
		n.queue_free()
	for y in range(len(matrix)):
		for x in range(len(matrix[y])):
			if matrix[y][x] > 0:
				var block = resource_block.instance()
				block.position = Vector2(x*16, y*16)
				add_child(block)
