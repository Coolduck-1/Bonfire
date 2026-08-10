extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WALL_JUMP_FORCE = Vector2(250, -300)


@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_duration: Timer = $DashDuration
@onready var dash_effect: Timer = $DashEffect
@onready var dash_cooldown: Timer = $"DashCooldown"




var direction = 0
var double_jumps = 0
var is_wall_sliding = false
var friction = 100
var is_dashing = false
var can_dash = true
var dash_speed = 3
var health = 1
var isHit = false
var wall_direction = 0
var dead = false

func dash_after_effect():
	var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D.duplicate()
	var animation_time = dash_duration.wait_time / dash_speed
	var fade_steps = 10
	var fade_amount = 0.4
	
	get_parent().add_child(animated_sprite_2d)
	animated_sprite_2d.global_position = global_position
	
	for i in range(fade_steps):
		await get_tree().create_timer((animation_time)).timeout
		animated_sprite_2d.modulate.a - fade_amount
		
	animated_sprite_2d.queue_free()


func dash():
	if (Input.is_action_just_pressed("dash") and can_dash):
		is_dashing = true
		can_dash = false
		dash_cooldown.start()
		dash_duration.start()
		dash_effect.start()
 	
	if is_dashing:
		velocity.x = direction * SPEED * dash_speed
		velocity.y = 0


#animate the actions
func animate():
	if (velocity.x == 0 and velocity.y == 0):
		animated_sprite.play("idle")
	
	if (is_on_floor() and velocity.y < 0):
		animated_sprite.play("jump")
	
	if (velocity.y < 0):
		animated_sprite.play("jump")
	
	if ((velocity.x > 0 or velocity.x < 0) and velocity.y == 0):
		animated_sprite.play("running")
	
	if (is_wall_sliding):
		animated_sprite.play("wall sliding")

	if isHit:
		animated_sprite.play("hit")

#double jumping
func double_jump():
	if(not is_on_floor() and double_jumps < 1 and Input.is_action_just_pressed("ui_accept")):
		velocity.y = JUMP_VELOCITY
		double_jumps += 1
	if (is_on_floor()):
		double_jumps = 0
		
	

func get_direction():
	direction = Input.get_axis("ui_left", "ui_right")
	if direction > 0:
		animated_sprite.flip_h = false
	if direction < 0:
		animated_sprite.flip_h = true
	


func _physics_process(delta: float) -> void:
	add_gravity(delta)
	animate()
	jump()
	double_jump()
	wall_slide()
	get_direction()
	run()
	dash()
	move_and_slide()


#handles death code
func death():
	dead = true
	velocity.y = 800
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)

# i have absolutely no idea what this does but nothing works without it
func add_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
#jump code
func jump():
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

#handles the wall sliding
func wall_slide():
	if (is_on_wall()):
		if Input.is_action_pressed("ui_left"):
			wall_direction = -1
			is_wall_sliding = true
		elif Input.is_action_pressed("ui_right"):
			wall_direction = 1
			is_wall_sliding = true
	else:
		is_wall_sliding = false
			
	if is_wall_sliding:
		velocity.y = friction
		
	else:
		is_wall_sliding = false
		
	if is_wall_sliding:
		velocity.y = friction
		
		#wall jump
		if Input.is_action_just_pressed("ui_accept"):
			velocity.x = -wall_direction * WALL_JUMP_FORCE.x
			velocity.y = WALL_JUMP_FORCE.y
			double_jumps +=  1
			is_wall_sliding = false 




#run code like running for the player to do it not the code
func run():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func hit():
	health -= 1
	isHit = true
	if health <= 0:
		death()


func _on_dash_duration_timeout() -> void:
	is_dashing = false
	dash_effect.stop()

func _on_dash_cooldown_timeout() -> void:
	can_dash = true


func _on_dash_effect_timeout() -> void:
	dash_after_effect()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_tree().reload_current_scene()
