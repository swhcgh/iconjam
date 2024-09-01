extends Node

var rng = RandomNumberGenerator.new()

signal PIECE_REMOVAL(score, type)
signal SET_JENKEN(val)
signal START_JENKEN()

func _ready():
	rng.randomize()
