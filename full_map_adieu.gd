extends Node3D

@onready var conduits = [$"Half Map Adieu/conduit 1", $"Half Map Adieu/conduit 2", $"Half Map Adieu/conduit 3", $"Half Map Adieu/conduit 4", $"central conduit", $"Half Map Adieu2/conduit 4", $"Half Map Adieu2/conduit 3", $"Half Map Adieu2/conduit 2", $"Half Map Adieu2/conduit 1"]
@onready var conduits_adjacency = [
	0, 1,
	1, 2,
	2, 3,
	3, 4,
	4, 5,
	5, 6,
	6, 7,
	7, 8
]

@onready var end_screen = preload("res://EndGameScreen.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var green_win = true
	var red_win = true
	for c in conduits:
		if c.state != Conduit.ConduitState.Green:
			green_win = false
		if c.state != Conduit.ConduitState.Orange:
			red_win = false
	
	if green_win && Globulars.character != null:
		Globulars.winning_team = Character.Team.Green
		Globulars.character_team = Globulars.character.team
		get_tree().get_root().add_child(end_screen)
		get_tree().get_root().get_node("World").queue_free()
		
	elif red_win && Globulars.character != null:
		Globulars.winning_team = Character.Team.Orange
		Globulars.character_team = Globulars.character.team
		get_tree().get_root().add_child(end_screen)
		get_tree().get_root().get_node("World").queue_free()
