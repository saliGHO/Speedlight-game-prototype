class_name PlayerStateIdle extends PlayerState


#What happens when this state is initialized?
func init() -> void:
	pass


#What happens when we enter this state?
func enter() -> void :
	player.animation_player.play("Idle")
	pass


#What happends when we exit this state?
func exit() -> void:
	pass


#What happens when an input is pressed?
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("KeyJump"):
		return jump
	
	if event.is_action_pressed("KeyDown"):
		if player.one_way_platform_ray_cast.is_colliding() == true:
			player.position.y += 4
			return fall
		
	return next_state


#What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	if Input.is_action_pressed("KeyCrouch"):
		return crouch
	if player.direction.x != 0:
		return run
	return next_state


#What happens each physics_process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor() == false:
		return fall
	player.velocity.x = 0
	return next_state
