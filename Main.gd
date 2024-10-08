extends Node2D


onready var player_piece = $PlayerPiece

var placement = []
var total_score:int = 0
var current_mode = -1
var game_round = 1

var charge = [0,0,0]
var timerr

func _ready():
	
	utils.connect("PIECE_REMOVAL", self, "update_score")
	utils.connect("PIECE_REMOVAL", self, "update_score")
	utils.connect("SET_JENKEN", self, "set_mode")
	
#	randomize_doll()
	
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 3.0
	timer.connect("timeout", self, "randomize_doll")
	get_node("/root/Main").add_child(timer)
	timer.start()
	
func _process(delta):
	if timerr and timerr.time_left < 15.0:
		$ProgressBar3.value = 15.0 - timerr.time_left
	else:
		$ProgressBar3.value = 0
	
func _input(event):
	
#	if event.is_action_pressed("ui_down"):
#		player_piece.drop()
	if event.is_action_pressed("ui_left"):
		player_piece.move_left()
	if event.is_action_pressed("ui_right"):
		player_piece.move_right()
	if event.is_action_pressed("ui_up"):
		player_piece.rotate_pieces()
		
func update_score(score, type):

	total_score += score
	$Label2.text = str(total_score)
	
	if type == -1:
		return
		
	charge[type] += score
	$Node2D2.get_child(type).value = charge[type]
	if charge[type] > $Node2D2.get_child(type).max_value:
		explosion(type)
	
func explosion(type):
	
	game_round +=1
	$Label4.text = str(game_round)
	
	for a in range(3):
		charge[a] = 0
		$Node2D2.get_child(type).value = charge[type]
		
	print("explosion for " + str(type) + "!")
	
	var typenext
	
	if type == 0:
		typenext = 1
	elif type == 1:
		typenext = 2
	elif type == 2:
		typenext = 0
	
	var explode_set = []
	
	for a in $Grid2.get_children():
		if a.type == typenext:
			explode_set.append(a)
			
	var explode_count = explode_set.size()
	
	var points = explode_count ^ 2
	utils.emit_signal("PIECE_REMOVAL", points, -1)
	
	for a in explode_set:
		$Grid2.remove_child(a)
		a.queue_free()
		
	#TODO: if type beats godot's current mode, remove black randomly equal to the number of blocks removed
	if type == current_mode:
		var bcount = 0
		var bpieces = []
		for a in $Grid2.get_children():
			if a.type == 3:
				bpieces.append(a)
		if bpieces.size() < bcount:
			bpieces.shuffle()
			for a in range(0, bcount - bpieces.size()):
				bpieces.pop_back()
		
		var bpoints = (bpieces.size() ^ 3) * (timerr.time_left / 15.0)
		utils.emit_signal("PIECE_REMOVAL", bpoints, -1)
		
		for a in bpieces:
			$Grid2.remove_child(a)
			a.queue_free()
		
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = .05
	timer.connect("timeout", get_node("/root/Main"), "collapse")
	get_node("/root").add_child(timer)
	timer.start()
	
	
#determine if we have any members with at least 2 neighbors. doesn't meet the minimum to score,
# but it's a minimum to figure out what's worth checking
func check_sets():
	
	print("checking for sets that need solving")
	
	for a in $Grid2.get_children():
		if a.check_neighbors():
			to_solve.append(a)
	
	if to_solve.size() > 0:
		run_solves()
	
var to_solve = []
var set = []
var checked = []

#run solving checks on any pieces with at least two neighbors, recursively
func run_solves():
	
	print("running solves")
	
	while 1==1:
		if to_solve.size() == 0:
			return
		else:
			set.clear()
			checked.clear()
			solve(to_solve[0])
			if set.size() >= 4:
				resolve()
				to_solve.clear()
			else:
				to_solve.remove(0)

#TODO: make this work
func solve(start):

	checked.append(start)
	if !set.has(start):
		set.append(start)
	
	for a in start.get_neighbors():
		if !set.has(a):
			set.append(a)
		if !checked.has(a):
			solve(a)
			
func resolve():
	
	print("resolving scoring pieces")
	
	var points = set.size() * set.size()
	utils.emit_signal("PIECE_REMOVAL", points, set[0].type)
	
	for a in set:
		$Grid2.remove_child(a)
		a.queue_free()
		
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = .05
	timer.connect("timeout", get_node("/root/Main"), "collapse")
	get_node("/root").add_child(timer)
	timer.start()
	
func collapse():
	
	print("starting collapse process")
	
	var collapsing = false
	
	for a in $Grid2.get_children():
		var c = a.collapse()
		if c:
			collapsing = true
	
	if collapsing:
		var timer := Timer.new()
		timer.one_shot = true
		timer.wait_time = .05
		timer.connect("timeout", get_node("/root/Main"), "collapse")
		get_node("/root").add_child(timer)
		timer.start()
	
	else:
		print("done collapsing")
		
		var timer := Timer.new()
		timer.one_shot = true
		timer.wait_time = .05
		timer.connect("timeout", get_node("/root/Main"), "check_sets")
		get_node("/root").add_child(timer)
		timer.start()

func randomize_doll():
	
	get_node("/root/Main/Doll").set_mode(1)
	
	timerr = Timer.new()
	timerr.one_shot = true
	timerr.wait_time = 19.0
	timerr.connect("timeout", self, "randomize_doll")
	get_node("/root/Main").add_child(timerr)
	timerr.start()

func set_mode(r):
	current_mode = r
