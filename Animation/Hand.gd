extends Sprite

var timer
var tempmode = 0

func _ready():
	utils.connect("SET_JENKEN", self, "set_mode")
	utils.connect("START_JENKEN", self, "modulate")

func set_mode(r):
	
	if timer:
		timer.stop()
	
	if r == 0:
		set_modulate(Color(1, .25, .25, 1))
	elif r == 1:
		set_modulate(Color(.25, 1, .25, 1))
	elif r == 2:
		set_modulate(Color(.25, .25, 1, 1))

func modulate():
	
	if tempmode == 0:
		set_modulate(Color(1, .25, .25, 1))
		tempmode = 1
	elif tempmode == 1:
		set_modulate(Color(.25, 1, .25, 1))
		tempmode = 2
	elif tempmode == 2:
		set_modulate(Color(.25, .25, 1, 1))
		tempmode = 0
	
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = .05
	timer.connect("timeout", self, "modulate")
	add_child(timer)
	timer.start()
