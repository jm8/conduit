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
	# remove graph edges
	for c in $background.get_children():
		$background.remove_child(c)
	var ally_nodes = get_tree().get_nodes_in_group("allies")
	for i in ally_nodes.size():
		var pos = ally_nodes[i].position
		var ally_sprite = ally_sprites[i]
		var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
		(pos.z - map_aabb.position.z) / map_aabb.size.z)
		ally_sprite.position = Vector2(normalized_position.x * $background.size.x, 
		normalized_position.y * $background.size.y) + $background.position
	
	var conduit_nodes = get_tree().get_nodes_in_group("conduits")
	for i in conduit_nodes.size():
		var pos = conduit_nodes[i].position
		var conduit_sprite = conduit_sprites[i]
		var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
		(pos.z - map_aabb.position.z) / map_aabb.size.z)
		conduit_sprite.position = Vector2(normalized_position.x * $background.size.x, 
		normalized_position.y * $background.size.y) + $background.position
		for c in conduit_nodes[i].nexts:
			var l = Line2D.new()
			l.add_point(conduit_sprite.position - $background.position)
			var next_pos = c.position
			var normalized_next_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
			(pos.z - map_aabb.position.z) / map_aabb.size.z)
			l.add_point(Vector2(normalized_position.x * $background.size.x, 
			normalized_position.y * $background.size.y))
			if conduit_nodes[i].state == Conduit.ConduitState.Orange and c.state == Conduit.ConduitState.Orange:
				l.default_color = Color(1, 0.5, 1)
			elif conduit_nodes[i].state == Conduit.ConduitState.Green and c.state == Conduit.ConduitState.Green:
				l.default_color = Color(0, 1, 0)
			else:
				l.default_color = Color(0.75, 0.75, 0.75)
			$background.add_child(l)
			
	
	if Globulars.character != null:
		var pos = Globulars.character.position
		var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
			(pos.z - map_aabb.position.z) / map_aabb.size.z)
		player_sprite.position = Vector2(normalized_position.x * $background.size.x, 
			normalized_position.y * $background.size.y) + $background.position
		player_sprite.rotation = atan2(Globulars.character.rotation.x, Globulars.character.rotation.z)
		player_sprite.visible = true
	else:
		player_sprite.visible = false
