class_name Conduit
extends MeshInstance3D

enum ConduitState{
	NEUTRAL,
	TEAM_ONE,
	TEAM_TWO,
}

const capture_time: float = 10

var team_one_players: int = 0
var team_two_players: int = 0
var state: ConduitState = ConduitState.NEUTRAL
var team_one_capture_progress: float = 0
var team_two_capture_progress: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if team_one_players > 0 and team_two_players == 0:
		team_one_capture_progress += delta * team_one_players
		team_two_capture_progress = 0
	if team_two_players > 0 and team_one_players == 0:
		team_two_capture_progress += delta * team_two_players
		team_one_capture_progress = 0
	if team_two_players == 0 and team_one_players == 0:
		team_one_capture_progress = 0
		team_two_capture_progress = 0


func _on_capture_area_body_entered(body):
	var team = body.get("team")
	if team == 1:
		team_one_players += 1
	elif team == 2:
		team_two_players += 1
	else:
		print("unexpected team: ", team)


func _on_capture_area_body_exited(body):
	var team = body.get("team")
	if team == 1:
		team_one_players -= 1
	elif team == 2:
		team_two_players -= 1
	else:
		print("unexpected team: ", team)
