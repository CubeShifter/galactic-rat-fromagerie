extends Node2D

var tile_map_layer: TileMapLayer
var durability: float = 16.0

func _ready() -> void:
	_drill()

func _drill() -> void:
	if not tile_map_layer:
		queue_free()
		return

	var collected := [0, 0, 0, 0, 0]
	var remaining := durability
	var tile_pos := tile_map_layer.local_to_map(position)

	while remaining > 0:
		tile_pos += Vector2i(0, 1)
		var chunk_pos: Vector2i = tile_map_layer.world_to_chunk(tile_pos)
		if not tile_map_layer.chunks.has(chunk_pos):
			break

		var local_x:int = ((tile_pos.x % tile_map_layer.CHUNK_SIZE) + tile_map_layer.CHUNK_SIZE) % tile_map_layer.CHUNK_SIZE
		var local_y:int = ((tile_pos.y % tile_map_layer.CHUNK_SIZE) + tile_map_layer.CHUNK_SIZE) % tile_map_layer.CHUNK_SIZE
		var idx: int = local_y * tile_map_layer.CHUNK_SIZE + local_x
		var tile_dur: float = tile_map_layer.chunks[chunk_pos][idx]

		if tile_dur == INF:
			break

		if tile_dur > remaining:
			tile_map_layer.chunks[chunk_pos][idx] -= remaining
			break

		remaining -= tile_dur
		var atlas_x := tile_map_layer.get_cell_atlas_coords(tile_pos).x
		tile_map_layer.erase_cell(tile_pos)
		tile_map_layer.chunks[chunk_pos][idx] = 0.0
		if atlas_x >= 0 and atlas_x < 5:
			collected[atlas_x] += 1

	var player = tile_map_layer.player
	for i in range(5):
		player.cheese[i] += collected[i]
	player.update_ui()
	queue_free()
