extends CharacterBody2D

const JUMP_VELOCITY = -350

@onready var sprite: AnimatedSprite2D = $sprite
@onready var mine_ray: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += 600 * delta

	# Jump
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	if Input.is_action_pressed("left"):
		velocity.x = -120
		sprite.flip_h = false
		mine_ray.target_position.x = -16

	elif Input.is_action_pressed("right"):
		velocity.x = 120
		sprite.flip_h = true
		mine_ray.target_position.x = 16

	else:
		velocity.x = 0

	# Mining
	#if Input.is_action_just_pressed("mine"):
		#mine()

	move_and_slide()


func mine():
	if mine_ray.is_colliding():
		var pos = mine_ray.get_collision_point()

		var tilemap = get_parent().get_node("TileMap")

		var cell = tilemap.local_to_map(
			tilemap.to_local(pos)
		)

		tilemap.erase_cell(0, cell)
