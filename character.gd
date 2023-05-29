class_name Character extends CharacterBody3D

const BulletHole = preload("res://bullet_hole.tscn")
enum Team {
	Orange,
	Green
}

@onready var camera = %Camera
@onready var camera_rotation = %CameraRotation
@onready var camera_recoil = %CameraRecoil
@onready var animation_tree = $AnimationTree
@onready var gun_animation_player = %GunAnimationPlayer
@onready var body = $Armature/Skeleton3D/Body
@onready var gun3rd = %Gun3rd
@onready var gun1st = %Gun1st
@onready var hand = %Hand
@onready var healthbar = %Healthbar
@onready var raycast: RayCast3D = %RayCast

@export var regular_position: Vector3
@export var ads_position: Vector3
@export var max_health: float = 100
@export var health: float = max_health
@export var team: Team

var regular_damage = 10
var regular_fov = 70.0
var ads_fov = 50.0

var target_recoil = Vector3()
var target_hand_rotation = Vector3()
var healthbar_current: float = 0

@export var is_aiming = false

const SPEED = 12.0
const JUMP_VELOCITY = 10
const LERP_VAL = .125

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 20

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	if is_multiplayer_authority():
		Globulars.character = self

func _ready():
	animation_tree.active = true
	if not is_multiplayer_authority(): return

	healthbar.visible = true
	gun1st.visible = true
	body.visible = false
	gun3rd.visible = false

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true
	
	if randf() < 0.5:
		team = Team.Orange
	else:
		team = Team.Green

func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if not is_multiplayer_authority(): return

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		target_hand_rotation += Vector3(-event.relative.y, -event.relative.x, 0) * .001
		rotate_y(-event.relative.x * .005)
		camera_rotation.rotation.x += -event.relative.y * .005
		camera_rotation.rotation.x = clamp(-PI/2, camera_rotation.rotation.x, PI/2)

func _process(_delta):
	var local_velocity = transform.inverse().basis * velocity
	animation_tree.set("parameters/run/blend_position", Vector2(local_velocity.x, local_velocity.z) / 4)
	var total_x_rotation = (camera_rotation.transform * camera_recoil.transform).basis.get_euler().x
	animation_tree.set("parameters/look/blend_position", total_x_rotation / (PI/2))
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	animation_tree.set("parameters/aim_state/transition_request", "aiming" if is_aiming else "not_aiming")

	if not is_multiplayer_authority(): return

	healthbar_current = lerp(healthbar_current, health / max_health, .5)
	healthbar.material.set_shader_parameter("health", healthbar_current)

	hand.rotation = lerp(hand.rotation,target_hand_rotation, .2)
	target_hand_rotation = lerp(target_hand_rotation, Vector3(), .2)

	camera_recoil.rotation = lerp(camera_recoil.rotation, target_recoil, .2)
	target_recoil = lerp(target_recoil, Vector3(), .2)

	var target_hand_position: Vector3
	var target_fov
	is_aiming = Input.is_action_pressed("ads")
	if is_aiming:
		target_hand_position = ads_position
		target_fov = ads_fov
	else:
		target_hand_position = regular_position
		target_fov = regular_fov
	hand.position = lerp(hand.position, target_hand_position, .5)
	camera.fov = lerp(camera.fov, target_fov, 0.5)
	# if camera.fov == null:
	# 	camera.fov = target_fov
	# camera.fov = lerp(camera.fov, target_fov, .5)

	if Input.is_action_pressed("fire"):
		if not gun_animation_player.is_playing():
			if raycast.is_colliding():
				var hit = raycast.get_collider()
				if hit is Character:
					hit.take_damage.rpc(regular_damage)
				else:
					add_bullet_hole.rpc(raycast.global_position, raycast.get_collision_point(), raycast.get_collision_normal())
			target_recoil += Vector3(.15 + randf_range(-0.05, 0.05), randf_range(-0.05, 0.05), 0)
			play_fire_animation.rpc()
		gun_animation_player.play("fire")
	else:
		camera.transform.origin = Vector3()

@rpc
func play_fire_animation():
	animation_tree.set("parameters/aim_fire/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	animation_tree.set("parameters/fire/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

@rpc("any_peer")
func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()

@rpc("any_peer", "call_local")
func add_bullet_hole(raycast_position, collision_point, collision_normal):
	var decal = BulletHole.instantiate()
	get_node("/root").add_child(decal)
	decal.global_position = collision_point
	decal.look_at(raycast_position, collision_point + collision_normal)

func _physics_process(delta):
	if not is_multiplayer_authority(): return

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var current_speed = SPEED
	if is_aiming:
		current_speed /= 2
	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * current_speed, LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)

	move_and_slide()
