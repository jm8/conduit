extends Node

var enet_peer := ENetMultiplayerPeer.new()

var conduit_positions: Array[Vector3] = []

var character: Character