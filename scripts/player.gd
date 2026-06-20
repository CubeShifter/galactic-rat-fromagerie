extends CharacterBody2D

const JUMP_VELOCITY = -325
const WALL_JUMP_X = 180

var dir := -1 #Var for the players direction
@onready var right: RayCast2D = $Right
@onready var left: RayCast2D = $Left
@onready var sprite: AnimatedSprite2D = $sprite
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer" #Loads two other noads, the players sprite and the tilemap.

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += 600 * delta

	# Normal jump
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

		
		elif left.is_colliding():
			# Wall is on left
			velocity.y = -250
			velocity.x = WALL_JUMP_X
		elif right.is_colliding():
			# Wall is on right
			velocity.y = -250
			velocity.x = -WALL_JUMP_X

	# Horizontal movement
	if Input.is_action_pressed("ui_left"):
		velocity.x = -120
		sprite.flip_h = false
		dir = -1
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 120
		sprite.flip_h = true
		dir = 1
	else:
		# Don't stop horizontal movement immediately while wall jumping
		if is_on_floor():
			velocity.x = 0

	
	# Mining
	if Input.is_action_just_pressed("ui_accept"):
		if Input.is_action_pressed("ui_down"):
			tile_map_layer.destroy_tile(position + Vector2(0, 16))
			velocity.y = 70
		elif Input.is_action_pressed("ui_up"):
			tile_map_layer.destroy_tile(position - Vector2(0, 16))
		else:
			tile_map_layer.destroy_tile(position + dir * Vector2(16, 0))

	move_and_slide()
