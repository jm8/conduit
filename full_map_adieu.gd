extends Node3D

@onready var conduits = [$"Half Map Adieu/conduit 1", $"Half Map Adieu/conduit 2", $"Half Map Adieu/conduit 3", $"Half Map Adieu/conduit 4", $"central conduit", $"Half Map Adieu2/conduit 4", $"Half Map Adieu2/conduit 3", $"Half Map Adieu2/conduit 2", $"Half Map Adieu2/conduit 1"]
@onready var conduits_adjacency = [0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if conduits.all(func(c): c.state == Conduit.ConduitState.Green):
		print("team one victory!")
	elif conduits.all(func(c): c.state == Conduit.ConduitState.Orange):
		print("team two victory!")
