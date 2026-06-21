extends TileMapLayer

const CHUNK_SIZE = 32
const VIEW_DISTANCE = 3
const WORLD_SEED = 42

var chunks: Dictionary = {}  # Vector2i(chunk_x, chunk_y) -> PackedFloat32Array
var last_player_chunk := Vector2i(999999, 999999)

@onready var player: CharacterBody2D = $"../player"


func _ready() -> void:
	update_chunks()


func _process(_delta: float) -> void:
	var current_chunk = world_to_chunk(local_to_map(player.position))
	if current_chunk != last_player_chunk:
		last_player_chunk = current_chunk
		update_chunks()


func world_to_chunk(tile_pos: Vector2i) -> Vector2i:
	return Vector2i(
		floori(tile_pos.x / float(CHUNK_SIZE)),
		floori(tile_pos.y / float(CHUNK_SIZE))
	)


func update_chunks() -> void:
	var player_chunk = last_player_chunk

	for dy in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
		for dx in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
			var chunk_pos = player_chunk + Vector2i(dx, dy)
			if chunk_pos.y < 0:
				continue
			if not chunks.has(chunk_pos):
				generate_chunk(chunk_pos)
				

	var to_remove: Array = []
	for chunk_pos in chunks.keys():
		if (abs(chunk_pos.x - player_chunk.x) > VIEW_DISTANCE + 1 or
				abs(chunk_pos.y - player_chunk.y) > VIEW_DISTANCE + 1):
			to_remove.append(chunk_pos)

	for chunk_pos in to_remove:
		unload_chunk(chunk_pos)


func generate_chunk(chunk_pos: Vector2i) -> void:
	var data := PackedFloat32Array()
	data.resize(CHUNK_SIZE * CHUNK_SIZE)

	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%d,%d" % [chunk_pos.x, chunk_pos.y]) ^ WORLD_SEED
	var layer = chunk_pos.y
	
	for local_y in range(CHUNK_SIZE):
		for local_x in range(CHUNK_SIZE):
			var tile_pos := Vector2i(
				chunk_pos.x * CHUNK_SIZE + local_x,
				chunk_pos.y * CHUNK_SIZE + local_y
			)
			var num := rng.randf()
			var atlas_x: int
			var durability: float
			
			
			if num > 0.70:
				atlas_x = 5
				durability = INF
			elif num > 0.525:
				atlas_x = clamp(layer-1,0,4 )
				durability = pow(2,clamp(layer-1,0,4 ))
			elif num>0.175:
				atlas_x =  clamp(layer,0,4 )
				durability = pow(2,clamp(layer,0,4 ))
			else:
				atlas_x =  clamp(layer+1,0,4 )
				durability = pow(2,clamp(layer+1,0,4 ))

			set_cell(tile_pos, 0, Vector2i(atlas_x, 0))
			data[local_y * CHUNK_SIZE + local_x] = durability

	chunks[chunk_pos] = data


func unload_chunk(chunk_pos: Vector2i) -> void:
	for local_y in range(CHUNK_SIZE):
		for local_x in range(CHUNK_SIZE):
			erase_cell(Vector2i(
				chunk_pos.x * CHUNK_SIZE + local_x,
				chunk_pos.y * CHUNK_SIZE + local_y
			))
	chunks.erase(chunk_pos)


func explode_at(world_pos: Vector2, radius: int) -> Array:
	var center := local_to_map(world_pos)
	var collected := [0, 0, 0, 0, 0]
	for dy in range(-radius, radius + 1):
		for dx in range(-radius, radius + 1):
			if dx * dx + dy * dy > radius * radius:
				continue
			var tile_pos := center + Vector2i(dx, dy)
			var chunk_pos := world_to_chunk(tile_pos)
			if not chunks.has(chunk_pos):
				continue
			var local_x := ((tile_pos.x % CHUNK_SIZE) + CHUNK_SIZE) % CHUNK_SIZE
			var local_y := ((tile_pos.y % CHUNK_SIZE) + CHUNK_SIZE) % CHUNK_SIZE
			var idx := local_y * CHUNK_SIZE + local_x
			if chunks[chunk_pos][idx] == INF:
				continue
			var atlas_x := get_cell_atlas_coords(tile_pos).x
			erase_cell(tile_pos)
			chunks[chunk_pos][idx] = 0.0
			if atlas_x >= 0 and atlas_x < 5:
				collected[atlas_x] += 1
	return collected


func destroy_tile(pos: Vector2) -> int:
	var tile_pos := local_to_map(pos)
	var chunk_pos := world_to_chunk(tile_pos)

	if not chunks.has(chunk_pos):
		return -1

	var local_x := ((tile_pos.x % CHUNK_SIZE) + CHUNK_SIZE) % CHUNK_SIZE
	var local_y := ((tile_pos.y % CHUNK_SIZE) + CHUNK_SIZE) % CHUNK_SIZE
	var idx := local_y * CHUNK_SIZE + local_x

	if chunks[chunk_pos][idx] == INF:
		return -1

	chunks[chunk_pos][idx] -= 1.0 + Global.upgrades["Strength"]

	if chunks[chunk_pos][idx] <= 0.0:
		var atlas_coords := get_cell_atlas_coords(tile_pos)
		erase_cell(tile_pos)
		return atlas_coords.x

	return -1


func _on_timer_timeout() -> void:
	pass # Replace with function body.
