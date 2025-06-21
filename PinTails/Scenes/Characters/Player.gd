class_name Character 
extends CharacterBody3D


signal toggle_inventory_interface()
signal player_state_loaded()
signal player_just_landed()
signal player_dash_stopped()
signal on_skill_cd()

@onready var player_detected_mat = load("res://Scenes/Characters/PlayerDetected.material")
## Damage the player takes if falling from great height. Leave at 0 if you don't want to use this.
@export var fall_damage : int
## Fall velocity at which fall damage is triggered. This is negative y-Axis. -5 is a good starting point but might be a bit too sensitive.
@export var fall_damage_threshold : float = -15

## Flag if Stamina component isused (as this effects movement)
@export var is_using_stamina : bool = true 
#Components:
@onready var health_component = $HealthComponent
@onready var sanity_component = $SanityComponent
@onready var brightness_component = $BrightnessComponent
@onready var stamina_component = $StaminaComponent

# Node caching
@onready var player_input = $PlayerInputSynchronizer
@onready var player_hud = $UI/Player_HUD
@onready var player_tails = $UI/PlayerTails
@onready var player_interaction_component = $PlayerInteractionComponent
@onready var tail_manager = $TailManager
@onready var skill_manager = $SkillManager
@onready var skill_nodes = $SkillNodes
@onready var tail_config_menu = $UI/PlayerTails/TailConfigMenu
@onready var body: MeshInstance3D = $TempBodyMesh
@onready var neck: Node3D = $Neck
@onready var head: Node3D = $Neck/Head
@onready var eyes: Node3D = $Neck/Head/Eyes
@onready var camera: Camera3D = $Neck/Head/Eyes/Camera
@onready var animationPlayer: AnimationPlayer = $Neck/Head/Eyes/AnimationPlayer
@onready var wallrun_skill_node = $SkillNodes/WallRun
@onready var movement_motion_blur = $Neck/Head/Eyes/Camera/MovementMotionBlur
@onready var invi_screen_effect = $Neck/Head/Eyes/Camera/InviScreenEffect
@onready var player_effects_manager = $PlayerEffectsManager
@onready var screen_effects = $Neck/Head/Eyes/Camera/ScreenEffects

@onready var interaction_raycast: RayCast3D = $Neck/Head/Eyes/Camera/InteractionRaycast
@onready var standing_collision_shape: CollisionShape3D = $StandingCollisionShape
@onready var crouching_collision_shape: CollisionShape3D = $CrouchingCollisionShape
@onready var player_collision_area: Area3D = $PlayerCollisionArea
@onready var crouch_raycast: RayCast3D = $CrouchRayCast
@onready var sliding_timer: Timer = $SlidingTimer
@onready var footstep_timer: Timer = $FootstepTimer

# Adding carryable position for item control.
@onready var carryable_position = %CarryablePosition
@onready var footstep_player = $FootstepPlayer

@export_group("Audio")
## AudioStream that gets played when the player jumps.a
@export var jump_sound : AudioStream

@export_group("Movement Properties")
@export var JUMP_VELOCITY = 4.5
@export var WALKING_SPEED = 5.0
@export var SPRINTING_SPEED = 8.0
@export var CROUCHING_SPEED = 3.0
@export var CROUCHING_DEPTH = -0.9
@export var MOUSE_SENS = 0.25
@export var LERP_SPEED = 10.0
@export var AIR_LERP_SPEED = 6.0
@export var FREE_LOOK_TILT_AMOUNT = 5.0
@export var SLIDING_SPEED = 5.0
@export var WIGGLE_ON_WALKING_SPEED = 14.0
@export var WIGGLE_ON_SPRINTING_SPEED = 22.0
@export var WIGGLE_ON_CROUCHING_SPEED = 10.0
@export var WIGGLE_ON_WALKING_INTENSITY = 0.1 
@export var WIGGLE_ON_SPRINTING_INTENSITY = 0.2
@export var WIGGLE_ON_CROUCHING_INTENSITY = 0.05
@export var BUNNY_HOP_ACCELERATION = 0.1
@export var INVERT_Y_AXIS : bool = false

## STAIR HANDLING STUFF
@export_group("Stair Handling")
var is_step : bool = false
var step_check_height : Vector3 = STEP_HEIGHT_DEFAULT / STEP_CHECK_COUNT
var gravity_vec : Vector3 = Vector3.ZERO
var head_offset : Vector3 = Vector3.ZERO
var snap : Vector3 = Vector3.ZERO

## This sets the camera smoothing when going up/down stairs as the player snaps to each stair step.
@export var step_height_camera_lerp : float = 2.5

## This sets the height of what is still considered a step (instead of a wall/edge)
@export var STEP_HEIGHT_DEFAULT : Vector3 = Vector3(0, 0.5, 0)

## This sets the step slope degree check. When set to 0, tiny edges etc might stop the player in it's tracks. 1 seems to work fine.
@export var STEP_MAX_SLOPE_DEGREE : float = 0.0
const STEP_CHECK_COUNT : int = 2
const WALL_MARGIN : float = 0.001

@export_group("Ladder Handling")
var on_ladder : bool = false
@export var ladder_speed : float = 2.0

@export_group("Gamepad Properties")
@export var JOY_DEADZONE : float = 0.25
@export var JOY_V_SENS : int = 3
@export var JOY_H_SENS : int = 2

var input_dir : Vector2
var joystick_h_event
var joystick_v_event
var initial_carryable_height #DEPRECATED Used to change carryable position based if player is standing or crouching

var config = ConfigFile.new()

var dash_rate : Vector3
var dash_lerp_speed : float
var dash_length : float
var idle_dash_rate : Vector3

var current_speed = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction = Vector3.ZERO
var is_walking = false
var is_sprinting = false
var is_crouching = false
var is_dashing = false
var is_free_looking = false
var is_jumping = false
var is_falling = false 
var on_wall_run = false
var is_pouncing = false
var slide_vector = Vector2.ZERO
var wiggle_vector = Vector2.ZERO
var wiggle_index = 0.0
var wiggle_current_intensity = 0.0
var bunny_hop_speed = SPRINTING_SPEED
var last_velocity = Vector3.ZERO
var stand_after_roll = false
var is_movement_paused = false
var is_looking_around_paused = false
var is_dead : bool = false
var is_dmg_immuned : bool = false 
var temp = 0

## Player tail stats
var adtnl_movement_speed = 0
var adtnl_armor = 0
var adtnl_max_health = 0
var adtnl_footstep_silencer = 0
var adtnl_melee_dmg = 0

## Cache allocation of test motion parameters.
@onready var _params: PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
@onready var self_rid: RID = self.get_rid()
@onready var test_motion_result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()

## Wallrun
@export_group("Wallrun Skill Properties")
@export var wallrun_angle : float = 15.0
@export var wall_jump_power_h : float = 1.0
@export var wall_jump_power_v : float = 0.75
@export_range(0.0, 1.0) var wall_jump_factor : float = 0.4

@onready var wallrun_delay_default = wallrun_delay
var is_wallrunning = false
var can_wallrun = false
var wallrun_delay = 0.2
var wallrun_current_angle = 0
var side = ""
var is_wallrun_jumping = false
var wall_jump_dir = Vector3.ZERO
var _network_manager
var activated_skill = false

#@export_group("Player Properties")
var player := 1
var _is_player_invisible = false
@export var is_player_invisible : bool = false 


# Use this function to manipulate player attributes.
func increase_attribute(attribute_name: String, value: float) -> bool:
	match attribute_name:
		"health":
			if health_component.current_health == health_component.max_health:
				return false
			else:
				print("Adding ", value, " to current_health.")
				health_component.add(value)
				return true
		"health_max":
			health_component.max_health += value
			health_component.health_changed.emit(health_component.current_health,health_component.max_health)
			return true
		"sanity":
			if sanity_component.current_sanity == sanity_component.max_sanity:
				return false
			else:
				sanity_component.add(value)
				return true
		"sanity_max":
			sanity_component.max_sanity += value
			sanity_component.sanity_changed.emit(sanity_component.current_sanity,sanity_component.max_sanity)
			return true
		"stamina":
			if stamina_component.current_stamina == stamina_component.max_stamina:
				return false
			else:
				stamina_component.add(value)
				return true
		"stamina_max":
			stamina_component.max_stamina += value
			stamina_component.stamina_changed.emit(stamina_component.current_stamina,stamina_component.max_stamina)
			return true
		_:
			print("Increase attribute failed: no match.")
			return false


func decrease_attribute(attribute_name: String, value: float):
	match attribute_name:
		"health":
			health_component.subtract(value)
		"sanity":
			sanity_component.subtract(value)
		"stamina":
			stamina_component.subtract(value)
		_:
			print("Decrease attribute failed: no match.")


func take_damage(value):
	health_component.subtract(value)


func add_sanity(value):
	sanity_component.add(value)


func params(transform3d, motion) -> PhysicsTestMotionParameters3D:
	var params : PhysicsTestMotionParameters3D = _params
	params.from = transform3d 
	params.motion = motion
	params.recovery_as_collision = true
	return params


# Method to pause input (for Menu or Dialogues etc)
func on_pause_movement():
	if !is_movement_paused: 
		is_movement_paused = true
		is_looking_around_paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Method to unpause/continue input (for Menu or Dialogues etc)
func on_resume_movement():
	if is_movement_paused:
		is_movement_paused = false
		is_looking_around_paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func test_motion(transform3d: Transform3D, motion: Vector3) -> bool:
	return PhysicsServer3D.body_test_motion(self_rid, params(transform3d, motion), test_motion_result)

 
@rpc("any_peer", "call_local", "reliable")
func apply_vision_material():
	body.material_override.next_pass = player_detected_mat
	await get_tree().create_timer(2.0).timeout
	body.get_active_material(0).next_pass = null


func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	# Disables camera on non-host server setups, or dedicated server builds
	camera.current = false
	var mat = body.material_override
	var unique_mat = mat.duplicate()
	body.material_override = unique_mat 
	
	if is_multiplayer_authority():
		camera.make_current()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		# if this is actually a host mode, we need to setup network manager as it is also a server
		if GameplayManager.server_mode_selected:
			_network_manager = get_tree().get_current_scene().get_node("NetworkManager")
	else: 
		set_process(false)
		#set_process_input(false)
		_network_manager = get_tree().get_current_scene().get_node("NetworkManager")
		player_hud.hide()
		player_tails.hide()
	
	player = name.to_int()
	
	#Some Setup steps
	#CogitoSceneManager._current_player_node = self
	randomize()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	initial_carryable_height = carryable_position.position.y #DEPRECATED
	
	player_hud.setup_player_hud()
	health_component.death.connect(_on_death) # Hookup HealthComponent signal to detect player death
	brightness_component.brightness_changed.connect(_on_brightness_changed) # Hookup brightness component signal
	
	get_tree().get_root().get_node("Game").player_ready_signal.emit()
	
	#if is_multiplayer_authority() && (GameplayManager.local_host_mode || not multiplayer.is_server()):
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#else: 
		#set_process(false)
		#set_process_input(false)
	
	##player tail initialization
	#tail_manager.add_tail(MatchManager.match_players.get(PlayerAccount.username))
	#GameplayManager.emit_signal("tail_picked_up", MatchManager.match_players.get(PlayerAccount.username))
	player_dash_stopped.connect(_stop_dash)


func _input(event):
	#if multiplayer.is_server():
	if is_multiplayer_authority():
		_take_input(event)
	
	if event is InputEventMouseMotion and !is_looking_around_paused and is_multiplayer_authority():
		if is_free_looking:
			neck.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		
		if INVERT_Y_AXIS:
			head.rotate_x(-deg_to_rad(-event.relative.y * MOUSE_SENS))
		else:
			head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _process(delta): 
	# If SanityComponent is used, this decreases health when sanity is 0.
	if sanity_component.current_sanity <= 0:
		take_damage(health_component.no_sanity_damage * delta)


func _physics_process(delta): 
	#if multiplayer.is_server():
	if is_multiplayer_authority():
		_apply_player_controls(delta)
	
	#if not multiplayer.is_server() || GameplayManager.local_host_mode:
		#animate(current_animation, delta)


func _on_death(): 
	is_dead = true


func _on_brightness_changed(current_brightness,max_brightness):
	print("Brightness changed to ", current_brightness)
	if current_brightness <= 0:
		if sanity_component.is_recovering:
			sanity_component.stop_recovery()
		else:
			sanity_component.start_decay()
	else:
		sanity_component.stop_decay()
		print("Checking if ", (sanity_component.current_sanity/sanity_component.max_sanity), " < ", (current_brightness/max_brightness))
		if (sanity_component.current_sanity/sanity_component.max_sanity) < (current_brightness/max_brightness):
			sanity_component.start_recovery(2.0, (sanity_component.max_sanity/max_brightness) * current_brightness)


# reload options user may have changed while paused.
#func _reload_options():
	#var err = config.load(OptionsConstants.config_file_name)
	#if err == 0:
		#INVERT_Y_AXIS = config.get_value(OptionsConstants.section_name, OptionsConstants.invert_vertical_axis_key, true)


func _take_input(event):
	# Checking Analog stick input for mouse look
	if event is InputEventJoypadMotion and !is_looking_around_paused:
		if event.get_axis() == 2:
			joystick_v_event = event
		if event.get_axis() == 3:
			joystick_h_event = event


func _apply_player_controls(delta):
	if is_movement_paused or on_wall_run:
		return
		
	if on_ladder:
		_process_on_ladder(delta)  
		return
	
	is_falling = false 
	
	# Getting input direction
	if !is_dashing:
		input_dir = Input.get_vector("movement|left", "movement|right", "movement|forward", "movement|backward")
	
	# LERP the up/down rotation of whatever you're carrying.
	carryable_position.rotation.z = lerp_angle(carryable_position.rotation.z, head.rotation.x, 5 * delta)
	
	_process_movement(delta)
	_process_gravity(delta)
	_process_jump(delta)
	_process_wallrun()
	_process_wallrun_rotation(delta)
	_process_velocity(delta)
	_process_stair_stepping(delta)
	
	velocity += gravity_vec
	
	if is_falling:
		snap = Vector3.ZERO 
	
	_process_dash(delta)
	
	if !is_movement_paused:
		move_and_slide()
	
	# FOOTSTEP SOUNDS SYSTEM = CHECK IF ON GROUND AND MOVING
	_process_footstep_sound()
	
	_process_pounce()
	
	is_jumping = false


func _process_on_ladder(_delta):
	var input_dir = Input.get_vector("movement|left", "movement|right", "movement|forward", "movement|back")
	var jump = Input.is_action_pressed("player|jump")
	
	# Processing analog stick mouselook
	if joystick_h_event:
			if abs(joystick_h_event.get_axis_value()) > JOY_DEADZONE:
				if INVERT_Y_AXIS:
					head.rotate_x(deg_to_rad(joystick_h_event.get_axis_value() * JOY_H_SENS))
				else:
					head.rotate_x(-deg_to_rad(joystick_h_event.get_axis_value() * JOY_H_SENS))
				head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
				
	if joystick_v_event:
		if abs(joystick_v_event.get_axis_value()) > JOY_DEADZONE:
			neck.rotate_y(deg_to_rad(-joystick_v_event.get_axis_value() * JOY_V_SENS))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
	
	# Applying ladder input_dir to direction
	direction = (transform.basis * Vector3(input_dir.x,input_dir.y * -1,0)).normalized()
	velocity = direction * ladder_speed
	
	var look_vector = camera.get_camera_transform().basis
	if jump:
		velocity += look_vector * Vector3(JUMP_VELOCITY, JUMP_VELOCITY, JUMP_VELOCITY)
	
	# print("Input_dir:", input_dir, ". direction:", direction)
	move_and_slide()
	
	#Step off ladder when on ground
	if is_on_floor():
		on_ladder = false


func _process_movement(delta) -> void:
	if joystick_h_event and !is_movement_paused:
			if abs(joystick_h_event.get_axis_value()) > JOY_DEADZONE:
				if INVERT_Y_AXIS:
					head.rotate_x(deg_to_rad(joystick_h_event.get_axis_value() * JOY_H_SENS))
				else:
					head.rotate_x(-deg_to_rad(joystick_h_event.get_axis_value() * JOY_H_SENS))
				head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if joystick_v_event and !is_movement_paused:
		if abs(joystick_v_event.get_axis_value()) > JOY_DEADZONE:
			neck.rotate_y(deg_to_rad(-joystick_v_event.get_axis_value() * JOY_V_SENS))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
	
	if stand_after_roll:
		head.position.y = lerp(head.position.y, 0.0, delta * LERP_SPEED)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		stand_after_roll = false
	
	if Input.is_action_pressed("player|crouch") and !is_movement_paused or crouch_raycast.is_colliding():
		if is_on_floor():
			current_speed = lerp(current_speed, CROUCHING_SPEED, delta * LERP_SPEED)
		head.position.y = lerp(head.position.y, CROUCHING_DEPTH, delta * LERP_SPEED)
		carryable_position.position.y = lerp(carryable_position.position.y, initial_carryable_height-.8, delta * LERP_SPEED)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		wiggle_current_intensity = WIGGLE_ON_CROUCHING_INTENSITY
		wiggle_index += WIGGLE_ON_CROUCHING_SPEED * delta
		if is_sprinting and input_dir != Vector2.ZERO and is_on_floor():
			sliding_timer.start()
			slide_vector = input_dir
		elif !Input.is_action_pressed("player|sprint"):
			sliding_timer.stop()
		is_walking = false
		is_sprinting = false
		is_crouching = true
	else:
		head.position.y = lerp(head.position.y, 0.0, delta * LERP_SPEED)
		carryable_position.position.y = lerp(carryable_position.position.y, initial_carryable_height, delta * LERP_SPEED)
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		sliding_timer.stop()
		# Prevent sprinting if player is out of stamina.
		if Input.is_action_pressed("player|sprint") and is_using_stamina and stamina_component.current_stamina > 0:
			if !Input.is_action_pressed("player|jump") and !is_jumping:
				bunny_hop_speed = SPRINTING_SPEED
			current_speed = lerp(current_speed, bunny_hop_speed, delta * LERP_SPEED)
			wiggle_current_intensity = WIGGLE_ON_SPRINTING_INTENSITY
			wiggle_index += WIGGLE_ON_SPRINTING_SPEED * delta
			is_walking = false
			is_sprinting = true
			is_crouching = false
			movement_motion_blur.toggle_motion_blur(true)
		elif Input.is_action_pressed("player|sprint") and !is_using_stamina:	
			if !Input.is_action_pressed("player|jump") and !is_jumping:
				bunny_hop_speed = SPRINTING_SPEED
			current_speed = lerp(current_speed, bunny_hop_speed, delta * LERP_SPEED)
			wiggle_current_intensity = WIGGLE_ON_SPRINTING_INTENSITY
			wiggle_index += WIGGLE_ON_SPRINTING_SPEED * delta
			is_walking = false
			is_sprinting = true
			is_crouching = false
			movement_motion_blur.toggle_motion_blur(true)
		else:
			current_speed = lerp(current_speed, WALKING_SPEED, delta * LERP_SPEED)
			wiggle_current_intensity = WIGGLE_ON_WALKING_INTENSITY
			wiggle_index += WIGGLE_ON_WALKING_SPEED * delta
			is_walking = true
			is_sprinting = false
			is_crouching = false
			movement_motion_blur.toggle_motion_blur(false)
	
	if Input.is_action_pressed("free_look") or !sliding_timer.is_stopped():
		is_free_looking = true
		if sliding_timer.is_stopped():
			eyes.rotation.z = -deg_to_rad(
				neck.rotation.y * FREE_LOOK_TILT_AMOUNT
			)
		else:
			eyes.rotation.z = lerp(
				eyes.rotation.z, 
				deg_to_rad(4.0), 
				delta * LERP_SPEED
			)
	else:
		is_free_looking = false
		rotation.y += neck.rotation.y
		neck.rotation.y = 0
		eyes.rotation.z = lerp(
			eyes.rotation.z,
			0.0,
			delta*LERP_SPEED
		)


func _process_gravity(delta) -> void:
	if is_on_floor():
		snap = -get_floor_normal()
		gravity_vec = Vector3.ZERO
		
		can_wallrun = false
		is_wallrunning = false
		is_wallrun_jumping = false
		wallrun_delay = wallrun_delay_default
	else:
		snap = Vector3.DOWN
		gravity_vec = Vector3.DOWN * gravity * delta
		
		if is_pouncing: ##POUNCE SKILL
			gravity_vec = gravity_vec * (Vector3.DOWN * -3.0) 
		
		wallrun_delay = clamp(wallrun_delay - delta, 0, wallrun_delay_default)
		 
		if wallrun_delay == 0:
			can_wallrun = true
	
	## Wallrunning jump
	if Input.is_action_pressed("player|jump") and is_wallrunning:
		can_wallrun = false
		is_wallrunning = false
		velocity = Vector3.ZERO
		velocity.y = JUMP_VELOCITY * wall_jump_power_v
		is_wallrun_jumping = true
		
		if side == "LEFT":
			wall_jump_dir = global_transform.basis.x * wall_jump_power_h
		elif side == "RIGHT":
			wall_jump_dir = -global_transform.basis.x * wall_jump_power_h
		
		wall_jump_dir *= wall_jump_factor
	
	if is_wallrun_jumping:
		direction = (direction * (1 - wall_jump_factor)) + wall_jump_dir
		return


func _process_jump(delta) -> void:
	if !is_on_floor():
		#snap = Vector3.DOWN
		#velocity.y -= gravity * delta
		pass
	elif last_velocity.y == 0.0 and input_dir != Vector2.ZERO:
		wiggle_vector.y = sin(wiggle_index)
		wiggle_vector.x = sin(wiggle_index / 2) + 0.5
		eyes.position.y = lerp(
			eyes.position.y,
			wiggle_vector.y * (wiggle_current_intensity / 2.0), 
			delta * LERP_SPEED
		)
		eyes.position.x = lerp(
			eyes.position.x,
			wiggle_vector.x * wiggle_current_intensity, 
			delta * LERP_SPEED
		)
	else:
		snap = -get_floor_normal()
		eyes.position.y = lerp(eyes.position.y, 0.0, delta * LERP_SPEED)
		eyes.position.x = lerp(eyes.position.x, 0.0, delta * LERP_SPEED)
		
		if last_velocity.y <= -12.5:
			head.position.y = lerp(head.position.y, CROUCHING_DEPTH, delta * LERP_SPEED)
			standing_collision_shape.disabled = false
			crouching_collision_shape.disabled = true
			animationPlayer.play("roll")
		elif last_velocity.y <= -5.0:
			animationPlayer.play("landing")
			if is_multiplayer_authority():
				player_effects_manager.rpc("play_effect", 
						player_effects_manager.Effects.IMPACT_DUST, 
						name.to_int())
		
		screen_effects.toggle_motion_lines(false)
		
		# Taking fall damage
		if fall_damage > 0 and last_velocity.y <= fall_damage_threshold:
			#health_component.subtract(fall_damage)
			pass
	
	if (Input.is_action_pressed("player|jump") or is_jumping) and !is_movement_paused and is_on_floor():
		snap = Vector3.ZERO
		is_falling = true
		
		# If Stamina Component is used, this checks if there's enough stamina to jump and denies it if not.
		if is_using_stamina and stamina_component.current_stamina >= stamina_component.jump_exhaustion:
			decrease_attribute("stamina",stamina_component.jump_exhaustion)
		else:
			print("Not enough stamina to jump.")
			return
		
		movement_motion_blur.toggle_motion_blur(true)
		animationPlayer.play("jump")
		#Audio.play_sound(jump_sound)
		if !sliding_timer.is_stopped() and velocity == Vector3.ZERO:
			velocity.y = JUMP_VELOCITY * 1.5 
			sliding_timer.stop()
		else:
			velocity.y = JUMP_VELOCITY
		
		if is_pouncing:
			velocity.y *= 2.5
		
		if is_sprinting:
			bunny_hop_speed += BUNNY_HOP_ACCELERATION
		else:
			bunny_hop_speed = SPRINTING_SPEED


##<<<< WALLRUNNING SKILL >>>>
func _process_wallrun() -> void:
	if can_wallrun and wallrun_skill_node.is_skill_enabled:
		if is_on_wall() and Input.is_action_pressed("movement|forward") and Input.is_action_pressed("player|sprint"):
			var collision = get_slide_collision(0)
			var normal = collision.get_normal()
			
			var wallrun_dir = Vector3.UP.cross(normal)
			
			var player_view_dir = camera.global_transform.basis.z
			var dot = wallrun_dir.dot(player_view_dir)
			
			if dot > 0:
				wallrun_dir = -wallrun_dir
			
			wallrun_dir += -normal * 0.01
			is_wallrunning = true
			side = _get_side(collision.get_position())
			gravity_vec = Vector3.DOWN * -0.01
			direction = wallrun_dir
		else:
			is_wallrunning = false

 
func _process_wallrun_rotation(delta) -> void:
	if is_wallrunning:
		if side == "RIGHT":
			wallrun_current_angle += delta * 60
			wallrun_current_angle = clamp(wallrun_current_angle, -wallrun_angle, wallrun_angle)
		elif side == "LEFT":
			wallrun_current_angle -= delta * 60
			wallrun_current_angle = clamp(wallrun_current_angle, -wallrun_angle, wallrun_angle)
	else:
		if wallrun_current_angle > 0:
			wallrun_current_angle -= delta * 40
			wallrun_current_angle = max(0, wallrun_current_angle)
		elif wallrun_current_angle < 0:
			wallrun_current_angle += delta * 40
			wallrun_current_angle = min(wallrun_current_angle, 0)
	 
	neck.rotation_degrees = Vector3.BACK * wallrun_current_angle


func _get_side(point) -> String: 
	point = to_local(point)
	
	if point.x > 0:
		return "RIGHT"
	elif point.x < 0:
		return "LEFT"
	else:
		return "CENTER"
##<<<< WALLRUNNING SKILL >>>>


func _process_velocity(delta) -> void:
	if sliding_timer.is_stopped():
		if is_on_floor():
			direction = lerp(
				direction,
				(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),
				delta * LERP_SPEED
			)
		elif input_dir != Vector2.ZERO:
			direction = lerp(
				direction,
				(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),
				delta * AIR_LERP_SPEED
			)
	else:
		direction = (transform.basis * Vector3(slide_vector.x, 0.0, slide_vector.y)).normalized()
		current_speed = (sliding_timer.time_left / sliding_timer.wait_time + 0.5) * SLIDING_SPEED
	
	current_speed = clamp(current_speed, 3.0, 12.0)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	last_velocity = velocity
	
	if (velocity.y >= 5.0):
		screen_effects.toggle_motion_lines(true)
	else:
		screen_effects.toggle_motion_lines(false)


func _process_stair_stepping(delta) -> void:
	is_step = false
	
	if gravity_vec.y >= 0:
		for i in range(STEP_CHECK_COUNT):
			var step_height: Vector3 = STEP_HEIGHT_DEFAULT - i * step_check_height
			var transform3d: Transform3D = global_transform
			var motion: Vector3 = step_height
			
			var is_player_collided: bool = test_motion(transform3d, motion)
			
			if test_motion_result.get_collision_count() > 0 and test_motion_result.get_collision_normal(0).y < 0:
				continue
			
			if not is_player_collided:
				transform3d.origin += step_height
				motion = velocity * delta
				is_player_collided = test_motion(transform3d, motion)
				if not is_player_collided:
					transform3d.origin += motion
					motion = -step_height
					is_player_collided = test_motion(transform3d, motion)
					if is_player_collided:
						if test_motion_result.get_collision_count() > 0 and test_motion_result.get_collision_normal(0).angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
							head_offset = -test_motion_result.get_remainder()
							is_step = true
							global_transform.origin += -test_motion_result.get_remainder()
							break
				else:
					var wall_collision_normal: Vector3 = test_motion_result.get_collision_normal(0)
					
					transform3d.origin += test_motion_result.get_collision_normal(0) * WALL_MARGIN
					motion = (velocity * delta).slide(wall_collision_normal)
					is_player_collided = test_motion(transform3d, motion)
					if not is_player_collided:
						transform3d.origin += motion
						motion = -step_height
						is_player_collided = test_motion(transform3d, motion)
						if is_player_collided:
							if test_motion_result.get_collision_count() > 0 and test_motion_result.get_collision_normal(0).angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
								head_offset = -test_motion_result.get_remainder()
								is_step = true
								global_transform.origin += -test_motion_result.get_remainder()
								break
			else:
				var wall_collision_normal: Vector3 = test_motion_result.get_collision_normal(0)
				transform3d.origin += test_motion_result.get_collision_normal(0) * WALL_MARGIN
				motion = step_height
				is_player_collided = test_motion(transform3d, motion)
				if not is_player_collided:
					transform3d.origin += step_height
					motion = (velocity * delta).slide(wall_collision_normal)
					is_player_collided = test_motion(transform3d, motion)
					if not is_player_collided:
						transform3d.origin += motion
						motion = -step_height
						is_player_collided = test_motion(transform3d, motion)
						if is_player_collided:
							if test_motion_result.get_collision_count() > 0 and test_motion_result.get_collision_normal(0).angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
								head_offset = -test_motion_result.get_remainder()
								is_step = true
								global_transform.origin += -test_motion_result.get_remainder()
								break
	
	if not is_step and is_on_floor():
		var step_height: Vector3 = STEP_HEIGHT_DEFAULT
		var transform3d: Transform3D = global_transform
		var motion: Vector3 = velocity * delta
		var is_player_collided: bool = test_motion(transform3d, motion)
		
		if not is_player_collided:  
			transform3d.origin += motion
			motion = -step_height
			is_player_collided = test_motion(transform3d, motion)
			if is_player_collided:
				if test_motion_result.get_collision_count() > 0 and test_motion_result.get_collision_normal(0).angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
					head_offset = test_motion_result.get_travel()
					is_step = true
					global_transform.origin += test_motion_result.get_travel()
			else:
				is_falling = true
		else:
			if test_motion_result.get_collision_count() > 0 and test_motion_result.get_collision_normal(0).y == 0:
				var wall_collision_normal: Vector3 = test_motion_result.get_collision_normal(0)
				transform3d.origin += test_motion_result.get_collision_normal(0) * WALL_MARGIN
				motion = (velocity * delta).slide(wall_collision_normal)
				is_player_collided = test_motion(transform3d, motion)
				if not is_player_collided:
					transform3d.origin += motion
					motion = -step_height
					is_player_collided = test_motion(transform3d, motion)
					if is_player_collided:
						if test_motion_result.get_collision_count() > 0 and test_motion_result.get_collision_normal(0).angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
							head_offset = test_motion_result.get_travel()
							is_step = true
							global_transform.origin += test_motion_result.get_travel()
					else:
						is_falling = true
	
	if is_step and !is_falling:
		head.position -= head_offset
		head.position.y = lerp(head.position.y, 0.0, delta * step_height_camera_lerp)
	else:
		head_offset = head_offset.lerp(Vector3.ZERO, delta * LERP_SPEED)
		head.position.y = lerp(head.position.y, 0.0, delta * step_height_camera_lerp)


##<<<< DASH SKILL >>>>
func _process_dash(delta) -> void:
	if is_dashing:
		screen_effects.toggle_motion_lines(true)
		player_effects_manager.rpc("play_effect", 
				player_effects_manager.Effects.SMALL_IMPACT_DUST, 
				name.to_int())
		
		if input_dir == Vector2.ZERO:
			idle_dash_rate = Vector3(WALKING_SPEED * dash_rate.x, 1.0, WALKING_SPEED * dash_rate.z)
			velocity = lerp(velocity, (-camera.global_transform.basis.z.normalized() * idle_dash_rate), dash_lerp_speed)
		else:
			velocity = lerp(velocity, (velocity * dash_rate), dash_lerp_speed)
		
		temp += 1
		
		if temp >= (dash_length):
			_stop_dash()
	else:
		temp = 0


func _stop_dash() -> void:
	screen_effects.toggle_motion_lines(false)
	temp = 0
	
	if is_dashing:
		player_effects_manager.rpc("stop_effect",
				player_effects_manager.Effects.SMALL_IMPACT_DUST,
				name.to_int())
		
		is_dashing = false
		player_dash_stopped.emit()
##<<<< DASH SKILL >>>>


##<<<< POUNCE SKILL >>>>
func _process_pounce() -> void:
	if is_on_floor() and is_pouncing:
		is_pouncing = false
		player_just_landed.emit()
		screen_effects.toggle_motion_blur(true)
		await get_tree().create_timer(0.5).timeout
		screen_effects.toggle_motion_blur(false)
##<<<< POUNCE SKILL >>>>


func _process_footstep_sound() -> void:
	if is_on_floor() and velocity.length() >= 0.2:
		if footstep_timer.time_left <= 0:
			footstep_player.play()
			# These "magic numbers" determine the frequency of sounds depending on speed of player. Need to make these variables.
			if velocity.length() >= 3.4:
				footstep_timer.start(0.3) 
			else:
				footstep_timer.start(0.6)


func _on_sliding_timer_timeout() -> void:
	is_free_looking = false


func _on_animation_player_animation_finished(anim_name):
	stand_after_roll = anim_name == 'roll' and !is_crouching


func _on_player_property_synchronizer_synchronized():
	return
	
	if is_player_invisible == _is_player_invisible: 
		return #no changes on player's visibility
	
	var tween = get_tree().create_tween();
	
	if is_player_invisible:
		tween.tween_method(_set_player_alpha, 1.0, 0.0, 1.5)
	else:
		tween.tween_method(_set_player_alpha, 0.0, 1.0, 1.5)
		body.set_layer_mask_value(1, true)
	
	_is_player_invisible = is_player_invisible


func _set_player_alpha(value : float):
	var player_material = body.mesh.material.get_albedo()
	body.mesh.material.set_albedo(Color(player_material.r, player_material.g, player_material.b, value))
	
	if player_material.a < 0.1 and is_player_invisible:
		body.set_layer_mask_value(1, false)
		body.set_layer_mask_value(20, true)
