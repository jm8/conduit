extends Node

var enet_peer := ENetMultiplayerPeer.new()

var conduit_positions: Array[Vector3] = []

var character: Character

var world

var characters: Array[Character]

var gameui: GameUI

func update_characters():
	var new_characters: Array[Character] = []
	for i in range(world.get_child_count()):
		var n = world.get_child(i)
		if n is Character:
			new_characters.push_back(n)
	characters = new_characters
