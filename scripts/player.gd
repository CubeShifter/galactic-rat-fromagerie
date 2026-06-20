extends CharacterBody2D




const JUMP_VELOCITY = -325 #Defines constants

var dir := -1 #Var for the players direction

@onready var sprite: AnimatedSprite2D = $sprite
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer" #Loads two other noads, the players sprite and the tilemap.

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor(): #Manages falling
		velocity.y +=600 * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor(): #Jumping
		velocity.y = JUMP_VELOCITY

	
	if Input.is_action_pressed("ui_left"): #Left and right movement
		velocity.x = -120
		sprite.flip_h = false
		dir = -1
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 120
		sprite.flip_h = true
		dir = 1
	else:
		velocity.x = 0
		
	if Input.is_action_just_pressed("ui_accept"): # This checks if the mine button is pressed and if so mines
		if Input.is_action_pressed("ui_down"):
			tile_map_layer.destroy_tile(position+Vector2(0,16))
			velocity.y = 70
		elif Input.is_action_pressed("ui_up"):
			tile_map_layer.destroy_tile(position-Vector2(0,16))
		else:
			tile_map_layer.destroy_tile(position+ dir*Vector2(16,0))
		
		
	

	move_and_slide()
