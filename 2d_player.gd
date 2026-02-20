extends CharacterBody3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var spring_arm: SpringArm3D = $SpringArm3D

const WALK_SPEED := 5.0
const RUN_SPEED := 9.0
const JUMP_VELOCITY := 4.5
const MOUSE_SENSITIVITY := 0.003

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		spring_arm.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		spring_arm.rotation.x = clamp(
			spring_arm.rotation.x,
			deg_to_rad(-60),
			deg_to_rad(10)
		)

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement input
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Determine speed
	var current_speed := WALK_SPEED
	if Input.is_action_pressed("run"):
		current_speed = RUN_SPEED

	# Apply movement
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALK_SPEED)

	move_and_slide()
	_update_animation()

func _update_animation():
	# Flip sprite left/right
	if velocity.x > 0.1:
		animated_sprite_3d.flip_h = false
	elif velocity.x < -0.1:
		animated_sprite_3d.flip_h = true

	# Play correct animation
	if velocity.length() > 0.1:
		if Input.is_action_pressed("run"):
			animated_sprite_3d.play("run")
		else:
			animated_sprite_3d.play("walk")
	else:
		animated_sprite_3d.play("idle")
