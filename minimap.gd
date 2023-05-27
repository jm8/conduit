extends AspectRatioContainer

@export var map: VisualInstance3D;

var conduit_sprite_scene = preload("res://conduit_sprite.tscn")
var ally_sprite_scene = preload("res://ally_sprite.tscn")

var map_aabb: AABB;

var conduit_sprites: Array[Sprite2D];
var ally_sprites: Array[Sprite2D];
@onready var player_sprite = $PlayerSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	map_aabb = map.get_global_transform() * map.get_aabb()
	ratio = map_aabb.size.x / map_aabb.size.z
	for conduit in get_tree().get_nodes_in_group("conduits"):
		var conduit_sprite = conduit_sprite_scene.instantiate()
		conduit_sprites.append(conduit_sprite)
		add_child(conduit_sprite)

	for ally in get_tree().get_nodes_in_group("allies"):
		var ally_sprite = ally_sprite_scene.instantiate()
		ally_sprites.append(ally_sprite)
		add_child(ally_sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ally_nodes = get_tree().get_nodes_in_group("allies")
	for i in ally_nodes.size():
		var pos = ally_nodes[i].position
		var ally_sprite = ally_sprites[i]
		var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
		(pos.z - map_aabb.position.z) / map_aabb.size.z)
		if normalized_position.x > 1 or normalized_position.x < 0 or normalized_position.y > 1 or normalized_position.y < 0:
			ally_sprite.visible = false
		else:
			ally_sprite.visible = true
		ally_sprite.position = Vector2(normalized_position.x * $background.size.x, 
		normalized_position.y * $background.size.y) + $background.position
	
	var conduit_nodes = get_tree().get_nodes_in_group("conduits")
	for i in conduit_nodes.size():
		var pos = conduit_nodes[i].position
		var conduit_sprite = conduit_sprites[i]
		var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
		(pos.z - map_aabb.position.z) / map_aabb.size.z)
		if normalized_position.x > 1 or normalized_position.x < 0 or normalized_position.y > 1 or normalized_position.y < 0:
			conduit_sprite.visible = false
		else:
			conduit_sprite.visible = true
		conduit_sprite.position = Vector2(normalized_position.x * $background.size.x, 
		normalized_position.y * $background.size.y) + $background.position
	
	var pos = Globulars.character.position
	var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
		(pos.z - map_aabb.position.z) / map_aabb.size.z)
	player_sprite.position = Vector2(normalized_position.x * $background.size.x, 
		normalized_position.y * $background.size.y) + $background.position
	player_sprite.rotation = atan2(Globulars.character.rotation.x, Globulars.character.rotation.z)
