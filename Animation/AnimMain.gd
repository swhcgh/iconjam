extends Node2D

var mode = 0
var jcount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")

func idle_end():
	
	if mode == 0:
		$AnimationPlayer.play("Idle")
	elif mode == 1:
		$AnimationPlayer.play("Jenken")

func jenken_end():
	
	jcount += 1
	if jcount > 2:
		jcount = 0
		var r = utils.rng.randi_range(0,2)
		utils.emit_signal("SET_JENKEN", r)
		set_mode(0)
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Jenken")

func set_mode(m):
	mode = m
	if mode == 1:
		utils.emit_signal("START_JENKEN")
