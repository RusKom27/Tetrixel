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
		for x in range(width):
			matrix[y].append(0)

func print_matrix(matrix):
	print("______")
	for y in range(len(matrix)):
		var row = ""
		for x in range(len(matrix[y])):
			row += str(matrix[y][x]) + "|"
		print(row)

func draw_matrix():
	for n in get_children():
		remove_child(n)
		n.queue_free()
	for y in range(len(matrix)):
		for x in range(len(matrix[y])):
			if matrix[y][x] == 1:
				var block = resource_block.instance()
				block.position = Vector2(x*16, y*16)
				add_child(block)
