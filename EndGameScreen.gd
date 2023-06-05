extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Globulars.character_team == Globulars.winning_team:
		$CanvasLayer/Label.text = "YOU WIN"
	else:
		$CanvasLayer/Label.text = "YOU LOSE"
