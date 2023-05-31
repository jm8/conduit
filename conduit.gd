class_name Conduit
extends MeshInstance3D

enum ConduitState {
	Neutral,
	Orange,
	Green,
}

const capture_time: float = 10

var green_players: int = 0
var orange_players: int = 0
var state: ConduitState = ConduitState.Neutral
var orange_capture_progress: float = 0
var green_capture_progress: float = 0

@export var CAPTURE_TARGET: int = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == ConduitState.Neutral:
		if orange_players > 0 and green_players == 0:
			orange_capture_progress += delta * orange_players
		elif green_players > 0 and orange_players == 0:
			green_capture_progress += delta * green_players
		elif orange_players == 0 and green_players == 0:
			orange_capture_progress = max(0, orange_capture_progress - delta)
			green_capture_progress = max(0, green_capture_progress - delta)
		
		if orange_capture_progress > capture_time:
			state = ConduitState.Orange
			orange_capture_progress = capture_time
		elif green_capture_progress > capture_time: 
			state = ConduitState.Green
			green_capture_progress = capture_time
	elif state == ConduitState.Green:
		if orange_players > 0 and green_players == 0:
			green_capture_progress -= delta * orange_players
		else:
			green_capture_progress += delta * (1 + green_players)
		if green_capture_progress < 0:
			green_capture_progress = 0
			state = ConduitState.Neutral
	elif state == ConduitState.Orange:
		print("orange state")
		if green_players > 0 and orange_players == 0:
			orange_capture_progress -= delta * green_players
		else:
			orange_capture_progress += delta * (1 + green_players)
		if orange_capture_progress < 0:
			orange_capture_progress = 0
			state = ConduitState.Neutral
		
	set_instance_shader_parameter("capture_progress", max(orange_capture_progress, green_capture_progress) / CAPTURE_TARGET)
	if orange_capture_progress > green_capture_progress:
		set_instance_shader_parameter("capture_color", Color(1.0, 0.0, 0.0))
	else:
		set_instance_shader_parameter("capture_color", Color(0.0, 1.0, 0.0))

func _on_capture_area_body_entered(body):
	var team = body.get("team")
	if team == Character.Team.Orange:
		green_players += 1
	elif team == Character.Team.Green:
		green_players += 1

func _on_capture_area_body_exited(body):
	var team = body.get("team")
	if team == Character.Team.Orange:
		green_players -= 1
	elif team == Character.Team.Green:
		green_players -= 1
