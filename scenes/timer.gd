extends Timer

@onready var rich_text_label: RichTextLabel = $"../CanvasLayer3/TextureRect2/RichTextLabel"
@onready var home: Area2D = $"../home"
@onready var player: CharacterBody2D = $"../player"



func _process(_delta: float) -> void:
	var seconds := int(time_left)
	var minutes := seconds / 60
	seconds %= 60
	rich_text_label.text = "[center]" + str(int(time_left))
	
	rich_text_label.text = "[center]%d:%02d[/center]" % [minutes, seconds]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wait_time = 20 + 15 * Global.upgrades["Time"]


func _on_timeout() -> void:
	if home.get_overlapping_bodies().size():
		
		for i in range(5):
			Global.bank[i] += player.cheese[i]
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
