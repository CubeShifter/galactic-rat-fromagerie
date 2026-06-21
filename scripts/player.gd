extends CharacterBody2D

enum CheeseType { SOFT = 0, HARD = 1 }

var JUMP_VELOCITY = -275 - Global.upgrades["Move Speed"]*13
const WALL_JUMP_X = 180
var MOVE_SPEED = 80 + Global.upgrades["Move Speed"] * 10
const GRAVITY = 600

const BombScene = preload("res://scenes/bomb.tscn")

var dir := -1
var can_mine = true
var cheese := [0,0,0,0,0]
var jump_buffer := 0

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
	handle_bomb()

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
		jump_buffer = 8

	if jump_buffer > 0:
		jump_buffer -= 1
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_buffer = 0
		elif left.is_colliding():
			velocity.y = -225- Global.upgrades["Move Speed"]*13
			velocity.x = WALL_JUMP_X
			jump_buffer = 0
		elif right.is_colliding():
			velocity.y = -225 - Global.upgrades["Move Speed"]*13
			velocity.x = -WALL_JUMP_X
			jump_buffer = 0


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
	


func handle_bomb() -> void:
	if not Input.is_action_just_pressed("bomb"):
		return
	var bomb = BombScene.instantiate()
	bomb.position = position
	bomb.tile_map_layer = tile_map_layer
	bomb.radius = 2 + Global.upgrades["Bombs"]
	get_parent().add_child(bomb)


func update_ui():

	for i in range(5):
		v_box_container.get_node(String("RichTextLabel" + str(i+1))).text = str(cheese[i])
		
 


func _on_timer_timeout() -> void:
	can_mine = true
