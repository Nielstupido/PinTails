extends MultiplayerSynchronizer

@export var head : Node3D
@export var neck : Node3D
@export var eyes : Node3D
@export var camera_3D : Camera3D
@export var running := false
@export var jumping := false
@export var input_motion := Vector2()
@export var do_jump := false

@export var is_movement_paused = false
@export var is_looking_aroung_paused = false

const CAMERA_MOUSE_ROTATION_SPEED := 0.001
const CAMERA_X_ROT_MIN := deg_to_rad(-89.9)
const CAMERA_X_ROT_MAX := deg_to_rad(70)
const CAMERA_UP_DOWN_MOVEMENT = 1

var paused = false
signal pause
signal unpause

var _network_manager


func _ready():
	return 
	# Disables camera on non-host server setups, or dedicated server builds
	if not GAMEPLAYMANAGER.local_host_mode && multiplayer.is_server() || OS.has_feature("dedicated_server"):
		camera_3D.current = false
	
	if is_multiplayer_authority() && (GAMEPLAYMANAGER.local_host_mode || not multiplayer.is_server()):
		camera_3D.make_current()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		# if this is actually a host mode, we need to setup network manager as it is also a server
		if GAMEPLAYMANAGER.local_host_mode:
			_network_manager = get_tree().get_current_scene().get_node("NetworkManager")
	else: 
		set_process(false)
		set_process_input(false)
		owner.set_process(false)
		owner.set_process_input(false)
		_network_manager = get_tree().get_current_scene().get_node("NetworkManager")


#func _process(delta):
	## handle game pause with esc key
	#if Input.is_action_just_released("ui_cancel"):
		#paused = !paused
		#if paused:
			#input_motion = Vector2(0,0) 
			#running = false
			#pause_game()
		#else:
			#unpause_game()
	#
	#if not paused:
		#input_motion = Input.get_vector("left", "right", "forward", "backward")
		#
		#if Input.is_action_just_pressed("jump"):
			#jump.rpc()
			#
		#running = input_motion.length() > 0 && Input.is_action_pressed("sprint")


func _input(event):
	return 
	if event is InputEventMouseMotion and !owner.is_looking_aroung_paused and is_multiplayer_authority():
		if owner.is_free_looking:
			neck.rotate_y(deg_to_rad(-event.relative.x * owner.MOUSE_SENS))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			owner.rotate_y(deg_to_rad(-event.relative.x * owner.MOUSE_SENS))
		
		if owner.INVERT_Y_AXIS:
			head.rotate_x(-deg_to_rad(-event.relative.y * owner.MOUSE_SENS))
		else:
			head.rotate_x(deg_to_rad(-event.relative.y * owner.MOUSE_SENS))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func get_camera_rotation_basis() -> Basis:
	return eyes.global_transform.basis


@rpc("call_local")
func jump():
	# We have to use call_local to allow for hosting configurations, but we don't need to call this 
	# locally on the client since our server has authority over player movement
	if multiplayer.is_server():
		do_jump = true


@rpc("call_local")
func quit_game():
	if multiplayer.is_server():
		var sender_id = multiplayer.get_remote_sender_id()

		# Disconnection logic follows here
		_network_manager.close_client_after_quit_signal.emit(sender_id)


# pause / mouse capture 
func pause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#get_tree().paused = true #In case you want to pause the game
	pause.emit()
	$"../HUD".show()


func unpause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#get_tree().paused = false
	unpause.emit()
	$"../HUD".hide()


func _quit_pressed():
	# need players to be able to use mouse for menu
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	quit_game.rpc()
