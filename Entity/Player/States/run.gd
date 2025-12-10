class_name PlayerStateRun extends PlayerState

var small_jump_timer: float = 0

#What happens when this state is initialized?
func init() -> void:
	pass


#What happens when we enter this state?
func enter() -> void :
	player.animation_player.play("Run")
	pass


#What happends when we exit this state?
func exit() -> void:
	pass


#What happens when an input is pressed?
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("KeyJump"):
		return jump
	return next_state


#What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	if player.velocity.x == 0:
		return idle
	elif Input.is_action_just_pressed("KeyCrouch"):
		return crouch
	return next_state


#What happens each physics_process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.direction.x != 0:
		player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.move_speed, player.acceleration_rate)
	else:
		player.velocity.x = move_toward(player.velocity.x, player.direction.x * player.move_speed, player.deceleration_rate)
		
	if player.is_on_floor() == false:
		return fall
	return next_state
