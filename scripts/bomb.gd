extends Node2D

var tile_map_layer: TileMapLayer
var radius: int = 7

@onready var fuse_timer: Timer = $FuseTimer
@onready var label: Label = $Label
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	fuse_timer.wait_time = 2.0
	fuse_timer.one_shot = true
	fuse_timer.timeout.connect(_explode)
	fuse_timer.start()

	anim.play(anim.sprite_frames.get_animation_names()[0])





func _explode() -> void:
	if tile_map_layer:
		var collected: Array = tile_map_layer.explode_at(position, radius)
		var player = tile_map_layer.player
		for i in range(5):
			player.cheese[i] += collected[i]
		player.update_ui()
	queue_free()
