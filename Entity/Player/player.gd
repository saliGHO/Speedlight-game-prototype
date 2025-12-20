class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://drc2howp1ywlo")

#region /// On ready variables

@onready var sprite: Sprite2D = $Sprite
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var one_way_platform_ray_cast: RayCast2D = $OneWayPlatformRayCast

@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var crouch: PlayerStateCrouch = %Crouch
#endregion

#region /// Export variables

@export_group("Player velocity setting")
@export var move_speed: float = 80
@export var sprint_move_speed: float = 120
@export var acceleration: float = 14
@export var deceleration: float = 12
@export var crouch_deceleration_rate: float = 6

@export_group("Player jump settings")
@export var jump_velocity: float = 400.0
@export var max_fall_velocity: float = 400
@export var jump_buffer_time: float = 0.1
@export var coyote_time: float = 0.115

@export_group("Gravity")
@export var gravity: float = 800
@export var gravity_multiplier: float = 1.0
@export var fall_gravity_multiplier: float = 1.165
@export var air_speed: float = 1.2

@export_group("One way platforms")
@export var drop_await_idle: float = 0.1
@export var drop_await_fall: float = 0.15
#endregion

#region /// State machine variables
var states: Array [PlayerState]
var current_state: PlayerState:
	get: return states.front()
var previous_state: PlayerState:
	get: return states[1]
#endregion

#region /// Stantard variables
var direction: Vector2 = Vector2.ZERO
var crouch_while_falling = false
#endregion


func _ready() -> void:
	initialize_state()
	print($States.get_child_count())
	pass

func _unhandled_input(event: InputEvent) -> void:
	@warning_ignore("redundant_await")
	change_state(await current_state.handle_input(event))
	
	if Input.is_action_pressed("KeyCrouch") && current_state == fall or current_state == jump:
		crouch_while_falling = true
	if Input.is_action_just_released("KeyCrouch") or Input.is_action_just_released("KeyJump"):
		crouch_while_falling = false
	pass

func _process(delta: float) -> void:
	update_direction()
	@warning_ignore("redundant_await")
	change_state(await current_state.process(delta))
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -1000.0, max_fall_velocity)
	move_and_slide()
	change_state(current_state.physics_process(delta))
	
	pass

func update_velocity(_velocity: float, _acceleration: float) -> void:
	velocity.x = move_toward(velocity.x,_velocity, _acceleration)

func initialize_state() -> void:
	states = []
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self
		pass
		
	if states.size() == 0:
		return
	
	
	for state in states:
		state.init()
	
	change_state(current_state)
	current_state.enter()
	$Label.text = current_state.name
	pass

func change_state(new_state: PlayerState) -> void:
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front(new_state)
	current_state.enter()
	states.resize(get_child_count()+1)
	$Label.text = current_state.name
	pass

func update_direction() -> void:
	var prev_direction: Vector2 = direction
	var x_axis = Input.get_axis("KeyLeft","KeyRight")
	var y_axis = Input.get_axis("KeyUp","KeyDown")
	direction = Vector2 (x_axis, y_axis)
	
	if prev_direction.x != direction.x:
		if direction.x < 0:
			sprite.flip_h = true
		if direction.x > 0:
			sprite.flip_h = false
	
		
	pass

#func add_debug_indicator(color: Color = Color.RED) -> void:
	#var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	#get_tree().root.add_child(d)
	#d.global_position = global_position
	#d.modulate = color
	#await get_tree().create_timer(3.0).timeout
	#d.queue_free()
	#pass
