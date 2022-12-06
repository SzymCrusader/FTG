extends Node2D
@onready var tiles = $TileMap 
@onready var rng = RandomNumberGenerator.new()

@export var map_width = 0
@export var map_height = 0
@export var iterations = 1

@export var noise_density = 50
@onready var map = Vector2()
@onready var map_grid = []
# Called when the node enters the scene tree for the first time.
func _ready():
	map.x = map_width
	map.y = map_height 
	map_grid = make_noise(noise_density)
	print("noise done")
	map_grid = apply_cellular_automaton(map_grid, iterations)
	place_tiles(map_grid, tiles)
	
func make_noise(density):
	var noise_grid = []
	for i in map.y:
		noise_grid.append([])
		for j in map.x:
			noise_grid[i].append(0)
	
	
	for h in map.y:
		for w in map.x:
			var random = rng.randi_range(1, 100)
			if random > density:
				noise_grid[h][w] = 0
			else:
				noise_grid[h][w] = 1
	return noise_grid
func apply_cellular_automaton(grid, count):
	for i in count:
		print("Starting iteration ", i)
		var temp_grid = grid.duplicate(true)
		for h in map.y:
			for w in map.x:
				var neigbor_count = 0
				for y in range(h-1, h+2):
					for x in range(w-1, w+2):
						if (y>=0 and y <map.y) and (x>=0 and x < map.x):
							if y!=h or x!=w:
									if temp_grid[y][x] == 1:
										neigbor_count += 1
										
						else:
							neigbor_count += 1

				if neigbor_count > 4:
					grid[h][w] = 1
				else:
					grid[h][w] = 0
		print("Iteration ", i," done")
	return grid
func place_tiles(grid, tilemap):
	var coords = []
	print("placing tiles")
	for i in map.y:
		for j in map.x:
			if grid[i][j] == 1:
				coords.append(Vector2i(j, i))
				#tiles.set_cell(0,Vector2i(j, i),grid[i][j],Vector2i(0,0))
	print(len(coords))
	tiles.set_cells_terrain_connect(0, coords, 0, 0)


	
	
