extends Node2D
class_name PlayerPiece

var col:int

var piece_class = preload("res://Piece.tscn")

func _ready():
	set_home()

func set_home():
	self.global_position = get_node("/root/Main/Grid/PlayerSpawn").global_position
	col = 4

var d:float = 0.0

func _process(delta):
	d += delta
	if d > 0.5:
		d = 0
		drop()
		
func drop():
	self.global_position += Vector2(0, 32)

func move_left():
	if col == 0:
		return
		
	self.global_position += Vector2(-64, 0)
	col -= 1
	
func move_right():
	if col == 9:
		return
		
	self.global_position += Vector2(64, 0)
	col += 1

func _on_Area2D_area_entered(area):
	break_up()
	set_home()
	setup_new_pieces()
	get_node("/root/Main").call_deferred("check_sets")
	
func break_up():
	
	for a in $Pieces.get_children():
		$Pieces.remove_child(a)
		get_node("/root/Main/Grid2").add_child(a)
		a.align_with_grid()
	print("stuff")

func setup_new_pieces():
	var p = piece_class.instance()
	p.position += Vector2(0,64)
	$Pieces.add_child(p)
	
	p = piece_class.instance()
	$Pieces.add_child(p)
	
	p = piece_class.instance()
	p.position += Vector2(0,-64)
	$Pieces.add_child(p)

func rotate_pieces():
	for a in $Pieces.get_children():
		if a.position.y == 0:
			a.position.y = -64
		elif a.position.y == 64:
			a.position.y = 0
		elif a.position.y == -64:
			a.position.y = 64
