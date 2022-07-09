extends Node2D

onready var game_board = get_parent().get_node("GameBoard")

var matrix_resource = load("res://Scripts/Matrix.gd")
var block_resource = load("res://Components/Block.tscn")

var Matrix = null

func _ready():
	Matrix = matrix_resource.new()
	change_figure()
	

func _input(event):
	if event.is_action_pressed("ui_left"):
		figure_move(-Matrix.cell_size)
	if event.is_action_pressed("ui_right"):
		figure_move(Matrix.cell_size)
	if event.is_action("ui_down"):
		drop_down()
	if event.is_action_pressed("ui_rotate_left"):
		Matrix.rotate_matrix(self, game_board, -1)
		draw_matrix()
	if event.is_action_pressed("ui_rotate_right"):
		Matrix.rotate_matrix(self, game_board, 1)
		draw_matrix()

func figure_move(dir):
	position.x += dir
	if Matrix.collide(self, game_board):
		position.x -= dir
	
func drop_down():
	position.y += Matrix.cell_size
	if Matrix.collide(self, game_board):
		position.y -= Matrix.cell_size
		Matrix.merge(self, game_board)
		game_board.Matrix.matrix_sweep()
		game_board.draw_matrix()
		reset()

func reset():
	change_figure()
	if Matrix.collide(self, game_board):
		game_board.Matrix.clear_matrix()
		game_board.draw_matrix()

func change_figure():
	randomize()
	var types = "ILJOTSZ"
	var figure = get_figure(types[randi()%len(types)])
#	var color = Color(float(randi()%100)/100 + 0.4, \
#		float(randi()%100)/100 + 0.5, \
#		float(randi()%100)/100 + 0.4, 1)
	var texture_type = randi()%4
	for y in range(len(figure)):
		for x in range(len(figure[y])):
			if figure[y][x] != null:
				var block = block_resource.instance()
				block.position = Vector2(x * Matrix.cell_size, y * Matrix.cell_size)
				block.set_texture(texture_type)
				figure[y][x] = block
	Matrix.create_matrix(len(figure), len(figure[0]))
	Matrix.matrix = figure
	draw_matrix()
	position = Vector2(game_board.position.x + Matrix.cell_size*4, game_board.position.y)

func draw_matrix():
	for n in get_children():
		remove_child(n)
	for y in range(len(Matrix.matrix)):
		for x in range(len(Matrix.matrix[y])):
			if Matrix.matrix[y][x] != null:
				Matrix.matrix[y][x].position = Vector2(x * Matrix.cell_size, y * Matrix.cell_size)
				add_child(Matrix.matrix[y][x])

func get_figure(type):
	if type == 'I':
		return [
			[null, 1, null, null],
			[null, 1, null, null],
			[null, 1, null, null],
			[null, 1, null, null],
		]
	elif type == 'L':
		return [
			[null, 2, null],
			[null, 2, null],
			[null, 2, 2],
		]
	elif type == 'J':
		return [
			[null, 3, null],
			[null, 3, null],
			[3, 3, null],
		]
	elif type == 'O':
		return [
			[4, 4],
			[4, 4],
		]
	elif type == 'Z':
		return [
			[5, 5, null],
			[null, 5, 5],
			[null, null, null],
		]
	elif type == 'S':
		return [
			[null, 6, 6],
			[6, 6, null],
			[null, null, null],
		]
	elif type == 'T':
		return [
			[null, 7, null],
			[7, 7, 7],
			[null, null, null],
		]

func _on_Timer_timeout():
	drop_down()
