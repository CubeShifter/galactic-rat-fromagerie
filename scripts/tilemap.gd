extends TileMapLayer

var tiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_map() 
	for i in range(40,60):
		print(tiles[0][i],i)
		
		
func make_map():
	for i in range(300):
		tiles.append([])
		for j in range(100):
			var num = randf()
			if num > 0.7:
				set_cell(Vector2i(j-50,i),0,Vector2i(1,0))
				tiles[i].append(3)
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
