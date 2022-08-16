extends MeshInstance

var portal = load("res://portal.tscn")	
var deltasum = 0.0

func _ready():
	pass


func _process(delta):
	deltasum += delta
	
	if deltasum > 1:
		var portal_inst = portal.instance()
		portal_inst.transform.origin = self.get_global_transform().origin
		portal_inst.transform.basis = self.get_global_transform().basis
		get_node("/root/main").add_child(portal_inst)
		deltasum = 0.0
