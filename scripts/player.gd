extends CharacterBody2D

const JUMP_VELOCITY = -325
const WALL_JUMP_X = 180

var dir := -1 #Var for the players direction
var cheese := 0
@onready var right: RayCast2D = $Right
@onready var left: RayCast2D = $Left
@onready var sprite: AnimatedSprite2D = $sprite
@onready var cheese_label: RichTextLabel = $"../RichTextLabel"
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer" #Loads two other noads, the players sprite and the tilemap.

func update_ui():
	cheese_label.bbcode_enabled = true
	cheese_label.text = "[center]🧀 %d[/center]" % cheese

func _ready():
	update_ui()

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += 600 * delta

	# Normal jump
	if Input.is_action_just_pressed("up"):
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
	if Input.is_action_pressed("left"):
		velocity.x = -120
		sprite.flip_h = false
		dir = -1
	elif Input.is_action_pressed("right"):
		velocity.x = 120
		sprite.flip_h = true
		dir = 1
	else:
		# Don't stop horizontal movement immediately while wall jumping
		if is_on_floor():
			velocity.x = 0

	
	# Mining
	if Input.is_action_just_pressed("dig"):
		var mined_cheese := false

		if Input.is_action_pressed("down"):
			mined_cheese = tile_map_layer.destroy_tile(position + Vector2(0, 16))
			velocity.y = 70

		elif Input.is_action_pressed("up"):
			mined_cheese = tile_map_layer.destroy_tile(position - Vector2(0, 16))

		else:
			mined_cheese = tile_map_layer.destroy_tile(position + dir * Vector2(16, 0))

		if mined_cheese:
			cheese += 1
			update_ui()
	print(cheese)

	move_and_slide()
