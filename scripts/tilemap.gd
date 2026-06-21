extends TileMapLayer

var tiles = []
@onready var player: CharacterBody2D = $"../player"

func _ready() -> void:
	make_map() 
	for i in range(40,60):
		print(tiles[0][i],i)
# Called when the node enters the scene tree for the first time.
func make_map():
	for i in range(300):
		tiles.append([])
		for j in range(100):
			var num = randf()
			if num > 0.9:
				set_cell(Vector2i(j-50,i),0,Vector2i(2,0))
				tiles[i].append(INF)
			elif num > 0.7:
				set_cell(Vector2i(j-50,i),0,Vector2i(1,0))
				tiles[i].append(2)
			else:
				set_cell(Vector2i(j-50,i),0,Vector2i(0,0))
				tiles[i].append(1)
			
func destroy_tile(pos):
	
	var tile_pos = local_to_map(pos)
	print(pos,tile_pos)
	
	tiles[tile_pos.y][tile_pos.x+50] -= 1

	if tiles[tile_pos.y ][tile_pos.x+50] == 0:
		erase_cell(tile_pos)
		print(tile_pos)
		return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
