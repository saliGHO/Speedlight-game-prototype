class_name PlayerStateFall extends PlayerState

var coyote_timer: float = 0
var jump_buffer_timer: float = 0
var initial_gravity_multiplier: float = 0

#What happens when this state is initialized?
func init() -> void:
	pass


#What happens when we enter this state?
func enter() -> void :
	player.animation_player.play("Fall")
	initial_gravity_multiplier = player.gravity_multiplier
	player.gravity_multiplier = player.fall_gravity_multiplier
	if player.previous_state == jump:
		coyote_timer = player.coyote_time
	else:
		coyote_timer = player.coyote_time
	pass


#What happends when we exit this state?
func exit() -> void:
	player.gravity_multiplier = initial_gravity_multiplier
	pass


#What happens when an input is pressed?
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("KeyJump"):
		if coyote_timer > 0:
				return jump
		else:
			jump_buffer_timer = player.jump_buffer_time
	
	return next_state


#What happens each process tick in this state?
func process(delta: float) -> PlayerState:
	coyote_timer -= delta
	jump_buffer_timer -= delta
	return next_state


#What happens each physics_process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		player.add_debug_indicator(Color.RED)
		if jump_buffer_timer > 0 :
			return jump
		return idle
	player.velocity.x = player.direction.x * player.move_speed * player.air_speed
	return next_state
