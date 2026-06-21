extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var _timer_in_progress = false
	
	wait_time = 180
	start()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	pass


func _on_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
