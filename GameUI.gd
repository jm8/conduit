class_name GameUI extends CanvasLayer

@onready var healthbar = %Healthbar
@onready var status = %Status
@onready var minimap = %Minimap

func _ready():
	Globulars.gameui = self

func _process(_delta):
	if not Globulars.character:
		return
	if Globulars.character.visible:
		healthbar.visible = true
		healthbar.material.set_shader_parameter("health", Globulars.character.healthbar_current)
		status.text = ""
	elif Globulars.character.spectate_character:
		healthbar.visible = true
		healthbar.material.set_shader_parameter("health", Globulars.character.spectate_character.healthbar_current)
		status.text = "Spectating " + Globulars.character.spectate_character.name
	else:
		healthbar.visible = false
		status.text = ""
