extends Node2D

class_name Matrix

var block_resource = load("res://Components/Block.tscn")

var width = 0
var height = 0
var matrix = []

func create_matrix(_width, _heigth):
	width = _width
	height = _heigth
	matrix = []
	for y in range(height):
		matrix.append([])
		for _x in range(width):
			matrix[y].append(null)

func clear_matrix():
	for y in range(height):
		for x in range(width):
			matrix[y][x] = null
	
func matrix_sweep():
	var sweeped_rows = []
	for y in range(len(matrix)):
		var line_detected = true
		for x in range(len(matrix[y])):
			if matrix[y][x] == null:
				line_detected = false
		if line_detected:
			sweeped_rows.append(y)
			clear_row(y)
	return sweeped_rows
	
func clear_row(row):
	for x in range(len(matrix[row])):
		matrix[row][x] = null

	var rows = range(row)
	rows.invert()
	for y in rows:
		var temp = matrix[y]
		matrix[y] = matrix[y+1]
		matrix[y+1] = temp

func fill_row(row):
	for y in range(row):
		for x in range(len(matrix[0])):
			var block = Global.block_resource.instance()
			block.position = Vector2(x * Global.cell_size, y * Global.cell_size)
			matrix[len(matrix)-1-y][x] = block
			
func print_matrix():
	var line = ""
	for _x in range(len(matrix)):
		line += "_"
	print(line)
	for y in range(len(matrix)):
		var row = ""
		for x in range(len(matrix[y])):
			if matrix[y][x] == null:
				row += " `"
			else:
				row += "▩`"
				
		print(row)

func collide(entity, another_entity):
	var pos_in_matrix = to_matrix_pos(entity, another_entity)
	var another_matrix = another_entity.Matrix.matrix
	for y in range(len(matrix)):
		for x in range(len(matrix[y])):
			if matrix[y][x] != null:
				if y + pos_in_matrix.y >= len(another_matrix) or \
					x + pos_in_matrix.x < 0 or \
					x + pos_in_matrix.x >= len(another_matrix[0]) or \
					another_matrix[y + pos_in_matrix.y][x + pos_in_matrix.x] != null:
					return true
	return false

func rotate_matrix(entity, another_entity, dir):
	var prev_position = entity.position
	var offset = Vector2(Global.cell_size,Global.cell_size)
	rotate(dir)
	while(collide(entity, another_entity)):
		entity.position.x += offset.x
		if offset.x > 0:
			offset.x = -(offset.x + Global.cell_size)
		else:
			offset.x = -(offset.x - Global.cell_size)
		if offset.x > len(matrix[0])*Global.cell_size:
			rotate(-dir)
			entity.position.x = prev_position.x
			return

func rotate(dir):
	var N = len(matrix[0])
	if dir < 0:
		for row in matrix:
			row.invert()
		matrix.invert()
	for i in range(N):
		for j in range(i):
			var temp = matrix[i][j]
			matrix[i][j] = matrix[j][i]
			matrix[j][i] = temp
	for i in range(N):
		for j in range(int(N/2)):
			var temp = matrix[i][j]
			matrix[i][j] = matrix[i][N-j-1]
			matrix[i][N-j-1] = temp
	
func merge(entity, another_entity):
	var block_placed = false
	var pos_in_matrix = to_matrix_pos(entity, another_entity)
	var another_matrix = another_entity.Matrix.matrix
	for y in range(len(matrix)):
		for x in range(len(matrix[y])):
			if matrix[y][x] != null and \
			 y + pos_in_matrix.y < len(another_matrix) and \
			 x + pos_in_matrix.x < len(another_matrix[0]) and \
			 x + pos_in_matrix.x > -1:
				var block = block_resource.instance()
				block.copy(matrix[y][x])
				another_matrix[y + pos_in_matrix.y][x + pos_in_matrix.x] = block
				another_matrix[y + pos_in_matrix.y][x + pos_in_matrix.x].animate_creation()
				block_placed = true
	return block_placed
				
				
func to_matrix_pos(entity, another_entity):
	return Vector2(entity.global_position - another_entity.global_position) / \
					Vector2(Global.cell_size,Global.cell_size)
