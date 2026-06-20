extends CharacterBody2D

<<<<<<< HEAD



const JUMP_VELOCITY = -325 #Defines constants
=======
const JUMP_VELOCITY = -325
const WALL_JUMP_X = 180
>>>>>>> 5ff5c2a2eec06f2eaeed73ddb160cb534c968c86

var dir := -1 #Var for the players direction

@onready var sprite: AnimatedSprite2D = $sprite
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer" #Loads two other noads, the players sprite and the tilemap.

func _physics_process(delta: float) -> void:
<<<<<<< HEAD
	# Add the gravity.
	if not is_on_floor(): #Manages falling
		velocity.y +=600 * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor(): #Jumping
		velocity.y = JUMP_VELOCITY

	
	if Input.is_action_pressed("ui_left"): #Left and right movement
=======
	# Gravity
	if not is_on_floor():
		velocity.y += 600 * delta

	# Normal jump
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Wall jump
		elif is_on_wall():
			velocity.y = JUMP_VELOCITY

			# Push away from the wall
			if get_wall_normal().x > 0:
				# Wall is on left
				velocity.x = WALL_JUMP_X
			else:
				# Wall is on right
				velocity.x = -WALL_JUMP_X

	# Horizontal movement
	if Input.is_action_pressed("ui_left"):
>>>>>>> 5ff5c2a2eec06f2eaeed73ddb160cb534c968c86
		velocity.x = -120
		sprite.flip_h = false
		dir = -1
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 120
		sprite.flip_h = true
		dir = 1
	else:
<<<<<<< HEAD
		velocity.x = 0
		
	if Input.is_action_just_pressed("ui_accept"): # This checks if the mine button is pressed and if so mines
=======
		# Don't stop horizontal movement immediately while wall jumping
		if is_on_floor():
			velocity.x = 0

	if is_on_wall() and !is_on_floor() and velocity.y > 50:
		velocity.y = 50
	# Mining
	if Input.is_action_just_pressed("ui_accept"):
>>>>>>> 5ff5c2a2eec06f2eaeed73ddb160cb534c968c86
		if Input.is_action_pressed("ui_down"):
			tile_map_layer.destroy_tile(position + Vector2(0, 16))
			velocity.y = 70
		elif Input.is_action_pressed("ui_up"):
			tile_map_layer.destroy_tile(position - Vector2(0, 16))
		else:
			tile_map_layer.destroy_tile(position + dir * Vector2(16, 0))

	move_and_slide()
