extends Timer

@onready var rich_text_label: RichTextLabel = $"../CanvasLayer3/TextureRect2/RichTextLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rich_text_label.text = "[center]" + str(int(time_left))
