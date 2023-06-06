extends Node3D

const CharacterScene = preload("res://character.tscn")
const GameUIScene = preload("res://game_ui.tscn")

@onready var menu = $MainMenu
@onready var host_ui = $HostUi
@onready var address_entry = %AddressEdit
@onready var port_entry = %PortEdit

const PORT = 45865

func _enter_tree():
	Globulars.world = self

func _ready():
	var args := OS.get_cmdline_args()
	for arg in args:
		if arg.is_valid_int():
			var port = arg.to_int()
			host(port)
			return
	

func host(port):
	Globulars.enet_peer.create_server(port)
	multiplayer.multiplayer_peer = Globulars.enet_peer
	print("Starting server on *:", port)
#	multiplayer.peer_connected.connect(add_player)
#	multiplayer.peer_disconnected.connect(remove_player)
	menu.queue_free()
	host_ui.visible = true

func _on_host_button_pressed():
	var port = PORT if port_entry.text == "" else port_entry.text.to_int()
	host(port)
	
func _on_join_button_pressed():
	var address = "localhost" if address_entry.text == "" else address_entry.text
	var port = PORT if port_entry.text == "" else port_entry.text.to_int()
	Globulars.enet_peer.create_client(address, port)
	print("connecting to ", address, ":", port)
	multiplayer.multiplayer_peer = Globulars.enet_peer
	multiplayer.peer_connected.connect(enter_setup_screen)
	menu.queue_free()
	
	
	


func enter_setup_screen(peer_id):
	%SetupScreen.visible = true

func add_player(peer_id, team):
	if peer_id == 1:
		return
	var character = CharacterScene.instantiate()
	character.name = str(peer_id)
	character.team = team
	add_child(character)

func remove_player(peer_id):
	print("remove", peer_id)
	var player = get_node_or_null(str(peer_id))
	print(player)
	if player:
		player.queue_free()
