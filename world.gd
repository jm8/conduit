extends Node3D

const World = preload("res://world.tscn")
const CharacterScene = preload("res://character.tscn")

@onready var menu = $CanvasLayer
@onready var address_entry = %AddressEdit
@onready var port_entry = %PortEdit

const PORT = 45865

func _on_host_button_pressed():
	Globulars.enet_peer.create_server(PORT if address_entry.text == "" else int(port_entry.text))
	multiplayer.multiplayer_peer = Globulars.enet_peer
	print("Hello")
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(multiplayer.get_unique_id())

	menu.queue_free()
	
func _on_join_button_pressed():
	var address = "localhost" if address_entry.text == "" else address_entry.text
	var port = PORT if address_entry.text == "" else port_entry.text.to_int()
	Globulars.enet_peer.create_client(address, port)
	print("connecting to ", address, ":", port)
	multiplayer.multiplayer_peer = Globulars.enet_peer
	multiplayer.peer_connected.connect(add_player)
	menu.queue_free()

func add_player(peer_id):
	var character = CharacterScene.instantiate()
	character.name = str(peer_id)
	add_child(character)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
