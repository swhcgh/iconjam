extends Node2D


onready var player_piece = $PlayerPiece

var placement = []

func _ready():
	pass
#	var pp = load("res://PlayerPiece.tscn")
#	player_piece = pp.instance()
#
#	$".".add_child(player_piece)
	
func _input(event):
	
	if event.is_action_pressed("ui_down"):
		player_piece.drop()
	if event.is_action_pressed("ui_left"):
		player_piece.move_left()
	if event.is_action_pressed("ui_right"):
		player_piece.move_right()
	if event.is_action_pressed("ui_up"):
		player_piece.rotate_pieces()

func check_sets():
	
	for a in $Grid2.get_children():
		if a.check_neighbors():
			to_solve.append(a)
	
	run_solves()
	
var to_solve = []
var set = []
var checked = []

func run_solves():
	
	while 1==1:
		if to_solve.size() == 0:
			return
		else:
			set = []
			checked = []
			solve(to_solve[0])
			resolve()

#TODO: make this work
func solve(start):

	checked.append(start)
	
	for a in start.get_neighbors():
		if !set.contains(a):
			set.append(a)
		if !checked.contains(a):
			solve(a)
			
func resolve():
	pass
