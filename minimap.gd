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
	# map_aabb = map.get_global_transform() * map.get_aabb()
	map_aabb = AABB(Vector3(-100, 0, -100), Vector3(200, 1, 200))
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
		var pos = ally_nodes[i].global_position
		var ally_sprite = ally_sprites[i]
		var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
		(pos.z - map_aabb.position.z) / map_aabb.size.z)
		ally_sprite.position = Vector2(normalized_position.x * $background.size.x, 
		normalized_position.y * $background.size.y) + $background.position
	
	var conduit_nodes = Globulars.world.get_node("Map").conduits;
	for i in conduit_nodes.size():
		var pos = conduit_nodes[i].global_position
		var conduit_sprite = conduit_sprites[i]
		var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
		(pos.z - map_aabb.position.z) / map_aabb.size.z)
		conduit_sprite.position = Vector2(normalized_position.x * $background.size.x, 
		normalized_position.y * $background.size.y) + $background.position
	
	if Globulars.character != null:
		var pos = Globulars.character.global_position
		var normalized_position: Vector2 = Vector2((pos.x - map_aabb.position.x) / map_aabb.size.x,
			(pos.z - map_aabb.position.z) / map_aabb.size.z)
		player_sprite.position = Vector2(normalized_position.x * $background.size.x, 
			normalized_position.y * $background.size.y) + $background.position
		player_sprite.rotation = -Globulars.character.global_rotation.y
		player_sprite.visible = true
	else:
		player_sprite.visible = false
		
	var conduits_adjacency = Globulars.world.get_node("Map").conduits_adjacency
	var conduits = Globulars.world.get_node("Map").conduits
	for i in range(0, conduits_adjacency.size(), 2):
			print(i)
			var c1 = conduits[conduits_adjacency[i]]
			var c2 = conduits[conduits_adjacency[i + 1]]
		
			var cs1 = conduit_sprites[conduits_adjacency[i]]
			var cs2 = conduit_sprites[conduits_adjacency[i + 1]]
		
			var l = Line2D.new()
			
			l.add_point(cs1.position)
			l.add_point(cs2.position)
			
			
			if c1.state == Conduit.ConduitState.Orange and c2.state == Conduit.ConduitState.Orange:
				l.default_color = Color(1, 0.5, 1)
			elif c1.state == Conduit.ConduitState.Green and c2.state == Conduit.ConduitState.Green:
				l.default_color = Color(0, 1, 0)
			else:
				l.default_color = Color(0.75, 0.75, 0.75)
			print(l)
			$background.add_child(l)
