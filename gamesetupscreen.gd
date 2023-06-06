extends ColorRect

@onready var name_label_scene = preload("res://player_name_label_setup_screen.tscn")

@export var green_team = []
@export var red_team = []

@rpc("any_peer")
func add_green_player():
	var player_id = multiplayer.get_remote_sender_id();
	if green_team.find(player_id) == -1:
		green_team.append(player_id)
	
	match red_team.find(player_id):
		-1:
			pass
		_: 
			red_team.remove_at(red_team.find(player_id))
	
@rpc("any_peer")
func add_red_player():
	var player_id = multiplayer.get_remote_sender_id();
	if red_team.find(player_id) == -1:
		red_team.append(player_id)
	
	match green_team.find(player_id):
		-1:
			pass
		_: 
			green_team.remove_at(green_team.find(player_id))


func _on_green_team_list_gui_input(event: InputEvent):
	if event.is_action_pressed("fire"):
		add_green_player.rpc()
		


func _on_red_team_list_gui_input(event):
	if event.is_action_pressed("fire"):
		add_red_player.rpc()

func _process(delta):
	for c in %GreenTeamList.get_children():
		if c.name != "Label":
			c.queue_free()
	for c in %RedTeamList.get_children():
		if c.name != "Label":
			c.queue_free()
	
	for player in red_team:
		var name_label = name_label_scene.instantiate();
		name_label.text = str(player)
		%RedTeamList.add_child(name_label)
	for player in green_team:
		var name_label = name_label_scene.instantiate();
		name_label.text = str(player)
		%GreenTeamList.add_child(name_label)
