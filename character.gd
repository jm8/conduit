class_name Character extends CharacterBody3D

@onready var camera = %Camera
@onready var camera_rotation = %CameraRotation
@onready var camera_recoil = %CameraRecoil
@onready var animation_tree = $AnimationTree
@onready var gun_animation_player = %GunAnimationPlayer
@onready var body = $Armature/Skeleton3D/Body
@onready var gun3rd = %Gun3rd
@onready var gun1st = %Gun1st

var target_recoil = Vector3()

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = .125

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	if is_multiplayer_authority():
		Globulars.character = self

func _ready():
	animation_tree.active = true
	if not is_multiplayer_authority(): return
	
	gun1st.visible = true
	body.visible = false
	gun3rd.visible = false

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true
	pass

func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED	

func _unhandled_input(event):
	if not is_multiplayer_authority(): return

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera_rotation.rotation.x += -event.relative.y * .005
		print(camera_rotation.rotation.x)
		print(-PI/2, PI/2)
		camera_rotation.rotation.x = clamp(-PI/2, camera_rotation.rotation.x, PI/2)

func _process(_delta):
	var local_velocity = transform.inverse().basis * velocity
	animation_tree.set("parameters/run/blend_position", Vector2(local_velocity.x, local_velocity.z) / SPEED)
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if not is_multiplayer_authority(): return

	camera_recoil.rotation = lerp(camera_recoil.rotation, target_recoil, .2)
	target_recoil = lerp(target_recoil, Vector3(), .2)

	if Input.is_action_pressed("fire"):
		if not gun_animation_player.is_playing():
			target_recoil += Vector3(.15, randf_range(-0.05, 0.05), 0)
		gun_animation_player.play("fire")

	else:
		camera.transform.origin = Vector3()

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
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)

	move_and_slide()
