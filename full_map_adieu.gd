extends Node3D

@onready var conduits = [$"Half Map Adieu/conduit 1", $"Half Map Adieu/conduit 2", $"Half Map Adieu/conduit 3", $"Half Map Adieu/conduit 4", $"central conduit", $"Half Map Adieu2/conduit 4", $"Half Map Adieu2/conduit 3", $"Half Map Adieu2/conduit 2", $"Half Map Adieu2/conduit 1"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if conduits.all(func(c): c.state == Conduit.ConduitState.TEAM_ONE):
		print("team one victory!")
	elif conduits.all(func(c): c.state == Conduit.ConduitState.TEAM_ONE):
		print("team two victory!")
