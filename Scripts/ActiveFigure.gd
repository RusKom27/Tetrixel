extends Node2D

signal collision

onready var game_board = get_parent().get_node("GameBoard")
var resource_block = load("res://Components/Block.tscn")

var figure = [
	[0, 0, 0],
	[1, 1, 1],
	[0, 1, 0],
]


func _ready():
	draw_figure()

func _input(event):
	if event.is_action_pressed("ui_left"):
		figure_move(-16)
	if event.is_action_pressed("ui_right"):
		figure_move(16)
	if event.is_action_pressed("ui_down"):
		drop_down()
	if event.is_action_pressed("ui_rotate_left"):
		rotate_figure(-1)
	if event.is_action_pressed("ui_rotate_right"):
		rotate_figure(1)

func figure_move(dir):
	position.x += dir
	if collide():
		position.x -= dir
	
func drop_down():
	position.y += 16
	if collide():
		position.y -= 16
		merge()
		position.y = game_board.position.y

func draw_figure():
	for n in get_children():
		remove_child(n)
		n.queue_free()
	for y in range(len(figure)):
		for x in range(len(figure[y])):
			if figure[y][x] == 1:
				var block = resource_block.instance()
				block.position = Vector2(x*16, y*16)
				add_child(block)

func collide():
	var pos_in_matrix = get_position_in_matrix()
	for y in range(len(figure)):
		for x in range(len(figure[y])):
			if figure[y][x] == 1:
				if y + pos_in_matrix.y > len(game_board.matrix) - 1:
					return true
				if x + pos_in_matrix.x < 0 or x + pos_in_matrix.x > len(game_board.matrix[0]) - 1:
					return true
				if game_board.matrix[y + pos_in_matrix.y][x + pos_in_matrix.x] == 1:
					return true
	return false

func rotate_figure(dir):
	var N = len(figure[0])
	if dir < 0:
		for row in figure:
			row.invert()
		figure.invert()
	for i in range(N):
		for j in range(i):
			var temp = figure[i][j]
			figure[i][j] = figure[j][i]
			figure[j][i] = temp
	
	
	for i in range(N):
		for j in range(int(N/2)):
			var temp = figure[i][j]
			figure[i][j] = figure[i][N-j-1]
			figure[i][N-j-1] = temp
	draw_figure()
	
func merge():
	for y in range(len(figure)):
		for x in range(len(figure[y])):
			if figure[y][x] == 1:
				game_board.matrix[y + get_position_in_matrix().y][x + get_position_in_matrix().x] = figure[y][x]
	game_board.draw_matrix()

func get_position_in_matrix():
	return Vector2((position.x - game_board.position.x)/16,(position.y - game_board.position.y)/16) 

func _on_Timer_timeout():
	drop_down()
