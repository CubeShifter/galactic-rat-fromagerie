extends Control

var texts = ["Speed","Strength","Bombs","Time","Drill"]
var numerals = ["I","II","III","IV",""]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(5):
		get_node("Control/RichTextLabel"+str(i+1)).text = "[center]"+str(Global.bank[i])
	for i in range(5):
		
		get_node("HBoxContainer/RichTextLabel"+str(i+1)).text = texts[i] +" "+ numerals[Global.upgrades[texts[i]]] 
		get_node("HBoxContainer/RichTextLabel"+str(i+1)+"/AnimatedSprite2D")

func _on_texture_button_1_pressed() -> void:
	pass # Replace with function body.


func _on_texture_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_texture_button_3_pressed() -> void:
	pass # Replace with function body.
