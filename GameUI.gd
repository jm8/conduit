class_name GameUI extends CanvasLayer

@onready var healthbar = %Healthbar
@onready var status = %Status
@onready var minimap = %Minimap
@onready var overheatbar = %OverheatBar

func _ready():
	Globulars.gameui = self

func _process(_delta):
	if not Globulars.character:
		return
	var character = Globulars.character if Globulars.character.visible else Globulars.character.spectate_character
	if character:
		healthbar.visible = true
		healthbar.material.set_shader_parameter("health", Globulars.character.healthbar_current)
		overheatbar.value = character.overheat
		overheatbar.modulate = Color(0, 1, 1, character.overheat)
		overheatbar.visible = true
	else:
		healthbar.visible = false
		overheatbar.visible = false
	
	if Globulars.character.visible:
		status.text = ""
	elif Globulars.character.spectate_character:
		status.text = "Spectating " + Globulars.character.spectate_character.name
	else:
		status.text = ""
