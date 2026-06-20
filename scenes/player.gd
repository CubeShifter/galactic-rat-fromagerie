extends CharacterBody2D




const JUMP_VELOCITY = -350

@onready var sprite: AnimatedSprite2D = $sprite

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y +=600 * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("ui_left"):
		velocity.x = -120
		sprite.flip_h = false
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 120
		sprite.flip_h = true

	move_and_slide()
