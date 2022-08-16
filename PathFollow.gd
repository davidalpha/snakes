extends PathFollow

var segment = load("segment.tscn")
export var speed = 5
var run_path = false

func _ready():
	var seg_inst = segment.instance()
	add_child(seg_inst)

func _process(delta):
	if run_path:
		set_offset(get_offset() + speed * delta)
	
	elif Input.is_action_just_pressed("Go"):
		run_path = true
		
	
