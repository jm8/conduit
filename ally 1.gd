extends Marker3D

var d = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	d += delta
	position = Vector3(5 * cos(d), 0, 5 * sin(d))
