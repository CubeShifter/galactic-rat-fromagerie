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
		get_node("HBoxContainer/RichTextLabel"+str(i+1)+"/AnimatedSprite2D").play(str(Global.upgrades[texts[i]]))

func _on_texture_button_1_pressed() -> void:
	print("meow")
	if Global.bank[Global.upgrades[texts[0]]] >= 20:
		Global.bank[Global.upgrades[texts[0]]] -= 20
		Global.upgrades[texts[0]] += 1
		


func _on_texture_button_2_pressed() -> void:
	if Global.bank[Global.upgrades[texts[1]]] >= 25:
		Global.bank[Global.upgrades[texts[1]]] -= 25
		Global.upgrades[texts[0]] += 1
		


func _on_texture_button_3_pressed() -> void:
	if Global.bank[Global.upgrades[texts[2]]] >= 30:
		Global.bank[Global.upgrades[texts[2]]] -= 30
		Global.upgrades[texts[0]] += 1
		


func _on_texture_button_4_pressed() -> void:
	if Global.bank[Global.upgrades[texts[3]]] >= 35:
		Global.bank[Global.upgrades[texts[3]]] -= 35
		Global.upgrades[texts[0]] += 1
		


func _on_texture_button_5_pressed() -> void:
	if Global.bank[Global.upgrades[texts[4]]] >= 45:
		Global.bank[Global.upgrades[texts[4]]] -= 45
		Global.upgrades[texts[0]] += 1
		


func _on_profanity_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
