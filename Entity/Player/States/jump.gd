class_name PlayerStateJump extends PlayerState



#What happens when this state is initialized?
func init() -> void:
	pass


#What happens when we enter this state?
func enter() -> void :
	player.animation_player.play("Jump")
	player.add_debug_indicator(Color.LIGHT_GREEN)
	player.velocity.y = -player.jump_velocity
	pass


#What happends when we exit this state?
func exit() -> void:
	player.add_debug_indicator(Color.YELLOW)
	pass


#What happens when an input is pressed?
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_released("KeyJump"):
		player.velocity.y *= 0.5
		return fall
	return next_state


#What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	return next_state


#What happens each physics_process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	return next_state
