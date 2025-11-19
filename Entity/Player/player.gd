class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://drc2howp1ywlo")

#region /// On ready variables
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#endregion

#region /// Export variables
@export var move_speed: float = 120
@export var jump_velocity: float = 400.0
@export var jump_buffer_time: float = 0.1
@export var gravity: float = 800
@export var gravity_multiplier: float = 1.0
@export var fall_gravity_multiplier: float = 1.165
@export var air_speed: float = 1.2
@export var coyote_time: float = 0.115

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
#endregion


func _ready() -> void:
	initialize_state()
	print($States.get_child_count())
	pass

func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))

func _process(delta: float) -> void:
	update_direction()
	change_state(current_state.process(delta))
	pass


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta * gravity_multiplier
	move_and_slide()
	change_state(current_state.physics_process(delta))
	pass

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
	#var prev_direction: Vector2 = direction
	var x_axis = Input.get_axis("KeyLeft","KeyRight")
	var y_axis = Input.get_axis("KeyUp","KeyDown")
	direction = Vector2 (x_axis, y_axis)
	pass

func add_debug_indicator(color: Color = Color.RED) -> void:
	var d : Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer(3.0).timeout
	d.queue_free()
	pass
