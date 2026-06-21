extends CharacterBody2D

enum CheeseType { SOFT = 0, HARD = 1 }

const JUMP_VELOCITY = -275
const WALL_JUMP_X = 180
const MOVE_SPEED = 120
const GRAVITY = 600

var dir := -1
var can_mine = true
var cheese := [0,0,0,0,0]

@onready var right: RayCast2D = $Right
@onready var left: RayCast2D = $Left
@onready var sprite: AnimatedSprite2D = $sprite
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
@onready var cheese_label: RichTextLabel = $"../CanvasLayer/RichTextLabel"
@onready var v_box_container: VBoxContainer = $"../CanvasLayer3/TextureRect/VBoxContainer"
@onready var timer: Timer = $Timer



func _ready() -> void:
	update_ui()

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement()
	handle_mining()

	move_and_slide()


# Movement
func handle_movement():
	if Input.is_action_pressed("left"):
		velocity.x = -MOVE_SPEED
		sprite.flip_h = false
		dir = -1

	elif Input.is_action_pressed("right"):
		velocity.x = MOVE_SPEED
		sprite.flip_h = true
		dir = 1

	else:
		velocity.x = 0


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta


func handle_jump():
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

		elif left.is_colliding():
			velocity.y = -225
			velocity.x = WALL_JUMP_X

		elif right.is_colliding():
			velocity.y = -225
			velocity.x = -WALL_JUMP_X


# MINING
func handle_mining():
	if not Input.is_action_just_pressed("dig") or not can_mine:
		return
	can_mine = false
	var offset := get_mine_offset()
	var mined: int = tile_map_layer.destroy_tile(position + offset)

	if mined >= 0:
		cheese[mined] += 1
		update_ui()
	timer.start()
		


func get_mine_offset() -> Vector2:
	if Input.is_action_pressed("down"):
		return Vector2(0, 16)
	elif Input.is_action_pressed("up"):
		return Vector2(0, -16)
	else:
		return Vector2(dir * 16, 0)
	


func update_ui():
	
	for i in range(5):
		v_box_container.get_node(String("RichTextLabel" + str(i+1))).text = str(cheese[i])
		
 


func _on_timer_timeout() -> void:
	can_mine=  true
