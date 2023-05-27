extends Node3D

const World = preload("res://world.tscn")
const Character = preload("res://character.tscn")

@onready var menu = $CanvasLayer
@onready var address_entry = $Panel/MarginContainer/VBoxContainer/AddressEdit

const PORT = 9999

func _on_host_button_pressed():
	Globulars.enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = Globulars.enet_peer
	print("Hello")
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())
	menu.queue_free()
	
func _on_join_button_pressed():
	Globulars.enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = Globulars.enet_peer
	multiplayer.peer_connected.connect(add_player)
	menu.queue_free()

func add_player(peer_id):
	var character = Character.instantiate()
	character.name = str(peer_id)
	add_child(character)
