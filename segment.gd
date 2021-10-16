extends MeshInstance

func _ready():
	transform.basis = transform.basis.rotated(transform.basis.x.normalized(),0)
