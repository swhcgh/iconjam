extends Node2D
class_name Piece

enum piece_type {RED, GREEN, BLUE}

var type:int
var x:int = -1
var y:int = -1

var last_collision

func _ready():
	randomize_type()

func randomize_type():
	type = utils.rng.randi_range(0,2)
	
	if type == 0:
		$Sprite.set_modulate(Color(1, .25, .25, 1))
	elif type == 1:
		$Sprite.set_modulate(Color(.25, 1, .25, 1))
	elif type == 2:
		$Sprite.set_modulate(Color(.25, .25, 1, 1))

func align_with_grid():
	if !last_collision:
		return
	else:
		x = last_collision.get_x()
		y = last_collision.get_y()
		self.global_position = last_collision.global_position
		$Area2D.call_deferred("set","monitorable", true)
		$Area2D.call_deferred("set","monitoring", true)


func _on_Area2D2_area_entered(area):
	last_collision = area.get_parent().get_parent()

func check_neighbors() -> bool:
	
	var count = 0
	for a in $Area2D3.get_overlapping_areas():
		if a.get_parent().type == self.type:
			count += 1
			
	if count > 1:
		return true
	else:
		 return false
		
func get_neighbors():
	var neighbors = []
	for a in $Area2D3.get_overlapping_areas():
		if a.get_parent().type == self.type:
			neighbors.append(a)
			
	return neighbors
