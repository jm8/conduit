extends ColorRect

@export var map: VisualInstance3D;

var conduit_sprite_scene = preload("res://conduit_sprite.tscn")

var map_aabb: AABB;

var conduit_sprites: Array[Sprite2D];


# Called when the node enters the scene tree for the first time.
func _ready():
	map_aabb = map.get_aabb()
	for pos in Globulars.conduit_positions:
		var conduit_sprite = conduit_sprite_scene.instantiate()
		conduit_sprites.append(conduit_sprite)
		var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
		(pos.z - map_aabb.position.z) / map_aabb.size.z)
		add_child(conduit_sprite)
		conduit_sprite.position = Vector2(normalized_position.x * size.x, 
		normalized_position.y * size.y)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
