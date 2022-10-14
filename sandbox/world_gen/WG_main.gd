extends Node2D
@onready var tiles = $TileMap 
@onready var rng = RandomNumberGenerator.new()

@export var map_width = 0
@export var map_height = 0
@export var iterations = 1

@onready @export var noise_density = 50
@onready var map = Vector2()
@onready var map_grid = []
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	map.x = map_width
	map.y = map_height 
	map_grid = make_noise(noise_density)
	print("noise done")
	place_tiles(map_grid)
	map_grid = apply_cellular_automaton(map_grid, iterations)

func make_noise(density):
	var noise_grid = []
	for i in map.y:
		noise_grid.append([])
		for j in map.x:
			noise_grid[i].append(0)
	
	var random = 1
	
	for h in map.y:
		for w in map.x:
			random = rng.randi_range(1,100)
			if random > density:
				noise_grid[h][w] = 1
			else:
				noise_grid[h][w] = 0
	return noise_grid
func apply_cellular_automaton(grid, count):
	for i in count:
		print("Starting iteration ", i)
		var temp_grid = grid.duplicate()
		for h in map.y:
			for w in map.x:
				var neigbor_count = 0
				for y in range(h-1,h+2):
					for x in range(w-1,w+2):
						if (y>=0 and y <map.y) and (x>=0 and x < map.x):
							if y!=h or x!=w:
									if temp_grid[y][x] == 1:
										neigbor_count+=1
										
						else:
							neigbor_count+=1

				if neigbor_count > 4:
					grid[h][w] = 1
				else:
					grid[h][w] = 0
		print("Iteration ", i," done")
	return grid
func place_tiles(grid):
	print("placing tiles")
	for i in map.y:
		for j in map.x:
			tiles.set_cell(0, Vector2i(j,i),grid[i][j],Vector2i(0,0))

func _physics_process(delta):
	if Input.is_action_just_pressed("player_up"):
			place_tiles(map_grid)
