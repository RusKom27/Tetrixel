extends Node2D

signal block_placed
signal blocks_sweeped
signal reset

onready var game_board = get_parent().get_node("GameBoard")
onready var next_figure_board = get_parent().get_node("NextFigureBoard")
onready var timer = get_parent().get_node("Timer")

var matrix_resource = load("res://Scripts/Matrix.gd")
var block_resource = load("res://Components/Block.tscn")

var Matrix = null

func _ready():
	Matrix = matrix_resource.new()
	change_figure()
	

func _input(event):
	if !timer.paused:
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
	if event.is_action_pressed("ui_pause"):
		get_parent().change_pause_state()
	if event.is_action_pressed("ui_restart"):
		get_parent().restart()
		
func figure_move(dir):
	position.x += dir
	if Matrix.collide(self, game_board):
		position.x -= dir
	
func drop_down():
	position.y += Matrix.cell_size
	if Matrix.collide(self, game_board):
		position.y -= Matrix.cell_size
		if Matrix.merge(self, game_board):
			emit_signal("block_placed")
		var sweeped_rows = game_board.Matrix.matrix_sweep()
		if len(sweeped_rows) > 0:
			emit_signal("blocks_sweeped", sweeped_rows)
		game_board.draw_matrix()
		reset()

func reset(restart = false):
	change_figure()
	if Matrix.collide(self, game_board) or restart:
		get_parent().update_stats()
		emit_signal("reset")
		change_figure()
		change_figure()
		game_board.Matrix.clear_matrix()
		game_board.draw_matrix()

func change_figure():
	var figure
	if next_figure_board.Matrix.matrix == []:
		figure = create_figure()
	else:
		figure = next_figure_board.Matrix.matrix
	var next_figure = create_figure()
	next_figure_board.Matrix.create_matrix(len(next_figure), len(next_figure[0]))
	next_figure_board.Matrix.matrix = next_figure
	
	next_figure_board.draw_matrix()
	
	Matrix.create_matrix(len(figure), len(figure[0]))
	Matrix.matrix = figure
	position = Vector2(game_board.position.x + Matrix.cell_size*4, game_board.position.y)
	draw_matrix()

func draw_matrix():
	for n in get_children():
		remove_child(n)
	for y in range(len(Matrix.matrix)):
		for x in range(len(Matrix.matrix[y])):
			if Matrix.matrix[y][x] != null:
				Matrix.matrix[y][x].position = Vector2(x * Matrix.cell_size, y * Matrix.cell_size)
				add_child(Matrix.matrix[y][x])

func create_figure():
	var types = "ILJOTSZ"
	var random_num
	for _i in range(5):
		random_num = randi()%len(types)
	var figure_type = get_figure_type(types[random_num])
	var texture_type = random_num%4
	for y in range(len(figure_type)):
		for x in range(len(figure_type[y])):
			if figure_type[y][x] != null:
				var block = block_resource.instance()
				block.position = Vector2(x * Matrix.cell_size, y * Matrix.cell_size)
				block.set_texture(texture_type, get_parent().level_color)
				figure_type[y][x] = block
	return figure_type

func get_figure_type(type):
	match type:
		'I':
			return [
				[null, 1, null, null],
				[null, 1, null, null],
				[null, 1, null, null],
				[null, 1, null, null],
			]
		'L':
			return [
				[null, 2, null],
				[null, 2, null],
				[null, 2, 2],
			]
		'J':
			return [
				[null, 3, null],
				[null, 3, null],
				[3, 3, null],
			]
		'O':
			return [
				[4, 4],
				[4, 4],
			]
		'Z':
			return [
				[5, 5, null],
				[null, 5, 5],
				[null, null, null],
			]
		'S':
			return [
				[null, 6, 6],
				[6, 6, null],
				[null, null, null],
			]
		'T':
			return [
				[null, 7, null],
				[7, 7, 7],
				[null, null, null],
			]

func _on_Timer_timeout():
	drop_down()
