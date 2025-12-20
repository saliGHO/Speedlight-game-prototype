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
	
	return next_state


#What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	if Input.is_action_pressed("KeyCrouch"):
		return crouch
		
	if Input.is_action_pressed("KeyDown") && player.one_way_platform_ray_cast.is_colliding() == true:
		if player.previous_state == fall:
			await get_tree().create_timer(player.drop_await_fall).timeout
			player.set_collision_mask_value(2,false)
			return fall
		else :
			await get_tree().create_timer(player.drop_await_idle).timeout
			player.set_collision_mask_value(2,false)
			return fall
	
	if player.direction.x != 0:
		return run
	
	return next_state


#What happens each physics_process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor() == false:
		return fall
	player.velocity.x = 0
	
	return next_state
