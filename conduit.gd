class_name Conduit
extends MeshInstance3D

enum ConduitState {
	Neutral,
	Orange,
	Green,
}

const capture_time: float = 10

@export var green_players: int = 0
@export var orange_players: int = 0
@export var state: ConduitState = ConduitState.Neutral
@export var orange_capture_progress: float = 0
@export var green_capture_progress: float = 0

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
			green_capture_progress = min(capture_time, green_capture_progress +  delta * (1 + green_players))
		if green_capture_progress < 0:
			green_capture_progress = 0
			state = ConduitState.Neutral
	elif state == ConduitState.Orange:
		if green_players > 0 and orange_players == 0:
			orange_capture_progress -= delta * green_players
		else:
			orange_capture_progress = min(capture_time, orange_capture_progress + delta * (1 + green_players))
		if orange_capture_progress < 0:
			orange_capture_progress = 0
			state = ConduitState.Neutral
		
	set_instance_shader_parameter("capture_progress", max(orange_capture_progress, green_capture_progress) / capture_time)
	if orange_capture_progress > green_capture_progress:
		set_instance_shader_parameter("capture_color", Color(1.0, 0.0, 0.0))
	else:
		set_instance_shader_parameter("capture_color", Color(0.0, 1.0, 0.0))

func _on_capture_area_body_entered(body):
	var team = body.get("team")
	if team == Character.Team.Orange:
		orange_players += 1
	elif team == Character.Team.Green:
		green_players += 1

func _on_capture_area_body_exited(body):
	if not (body is Character):
		return
	var team = body.get("team")
	if team == Character.Team.Orange:
		orange_players -= 1
	elif team == Character.Team.Green:
		green_players -= 1
