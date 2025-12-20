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
		return jump
	
	return next_state

#What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	if Input.is_action_just_released("KeyCrouch"):
		return idle
		
	if Input.is_action_pressed("KeyDown") && player.one_way_platform_ray_cast.is_colliding() == true:
			await get_tree().create_timer(player.drop_await_idle).timeout
			player.set_collision_mask_value(2,false)
			return fall
		
	return next_state


#What happens each physics_process tick in this state?
func physics_process(delta: float) -> PlayerState:
	player.velocity.x -= player.velocity.x * player.crouch_deceleration_rate * delta
	if player.is_on_floor() == false:
		return fall
		
	return next_state
