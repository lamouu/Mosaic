extends CharacterBody3D

@export var speed = 100
@export var acceleration = 5.0
@export var mouse_sensitivity = 0.003

@onready var camera = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_backwards", "move_forwards")
	var move_dir = Vector3.ZERO
	
	# Forward/backward and left/right movement
	move_dir += -transform.basis.z * input_dir.y
	move_dir += transform.basis.x * input_dir.x
	
	# Up/down movement
	if Input.is_action_pressed("jump"):
		move_dir += Vector3.UP
	if Input.is_action_pressed("down"):
		move_dir += Vector3.DOWN
	
	move_dir = move_dir.normalized()
	
	# Smooth acceleration
	velocity = velocity.lerp(move_dir * speed, acceleration * delta)
	
	move_and_slide()
