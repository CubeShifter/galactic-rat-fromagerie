extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(5):
		get_node("Control/RichTextLabel"+str(i+1)).text = "[center]"+str(Global.bank[i])
