class_name GameUI extends CanvasLayer

@onready var healthbar = %Healthbar
# @onready var status = %Status
@onready var minimap = %Minimap
@onready var overheatbar = %OverheatBar
@onready var greencharacters = %GreenCharacters
@onready var orangecharacters = %OrangeCharacters

func _ready():
	Globulars.gameui = self

func _process(_delta):
	if not Globulars.character:
		return
	var character = Globulars.character if Globulars.character.visible else Globulars.character.spectate_character
	if character:
		healthbar.visible = true
		healthbar.material.set_shader_parameter("health", character.healthbar_current)
		overheatbar.value = character.overheat
		overheatbar.modulate = Color(0, 1, 1, 0.5)
		overheatbar.visible = true
	else:
		healthbar.visible = false
		overheatbar.visible = false
	
	# if Globulars.character.visible:
	# 	status.text = ""
	# elif Globulars.character.spectate_character:
	# 	status.text = "Spectating " + Globulars.character.spectate_character.name
	# else:
	# 	status.text = ""

	greencharacters.text = ""
	orangecharacters.text = ""
	for c in Globulars.characters:
		var label = orangecharacters if (c.team == Character.Team.Orange) else greencharacters
		if label == greencharacters:
			label.text += c.name + " "
		if c == Globulars.character:
			label.text += "(you) "
		if c == Globulars.character.spectate_character:
			label.text += "(spectating) "
		if c.dead:
			label.text += "(respawn in %d) " % ceil(c.respawn_timer + c.respawn_start_time - Time.get_unix_time_from_system())
		if label == orangecharacters:
			label.text += c.name
		label.text += "\n"
