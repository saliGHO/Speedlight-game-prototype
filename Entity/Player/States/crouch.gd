class_name PlayerStateCrouch extends PlayerState


#What happens when this state is initialized?
func init() -> void:
	pass


#What happens when we enter this state?
func enter() -> void :
	player.animation_player.play("Crouch")
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	pass


#What happends when we exit this state?
func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	pass


#What happens when an input is pressed?
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("KeyJump"):
		if player.one_way_platform_ray_cast.is_colliding() == true:
			player.position.y += 4
			return fall
		return jump
	return next_state


#What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	if player.direction.y <= 0.4:
		return idle
	return next_state


#What happens each physics_process tick in this state?
func physics_process(delta: float) -> PlayerState:
	player.velocity.x -= player.velocity.x * player.deceleration_rate * delta
	if player.is_on_floor() == false:
		return fall
	return next_state
