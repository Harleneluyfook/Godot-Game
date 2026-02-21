extends CharacterBody3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var spring_arm: SpringArm3D = $SpringArm3D

const WALK_SPEED := 5.0
const RUN_SPEED := 9.0
const JUMP_VELOCITY := 4.5

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Input
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Camera-relative movement
	var cam_basis = spring_arm.global_transform.basis
	var forward = cam_basis.z
	var right = cam_basis.x
	
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var direction = (right * input_dir.x + forward * input_dir.y).normalized()

	# Speed
	var current_speed := WALK_SPEED
	if Input.is_action_pressed("run"):
		current_speed = RUN_SPEED

	# Apply movement
	if direction != Vector3.ZERO:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALK_SPEED)

	move_and_slide()

	_update_animation(input_dir)
	
func _update_animation(input_dir: Vector2):

	# Flip sprite
	if input_dir.x > 0:
		animated_sprite_3d.flip_h = false
	elif input_dir.x < 0:
		animated_sprite_3d.flip_h = true

	# Movement check
	if Vector2(velocity.x, velocity.z).length() > 0.1:

		# Side movement
		if abs(input_dir.x) > abs(input_dir.y):
			animated_sprite_3d.play("side")

		# Forward / Back
		else:
			if Input.is_action_pressed("run"):
				animated_sprite_3d.play("run")
			else:
				animated_sprite_3d.play("walk")
	else:
		animated_sprite_3d.play("idle")
