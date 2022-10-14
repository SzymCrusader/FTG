extends Node2D
@onready var tiles = $TileMap 

@onready var rng = RandomNumberGenerator.new()

@export var map_width = 0
@export var map_height = 0

@onready @export var noise_density = 50
@onready var map = Vector2()
@onready var noise_grid = []
# Called when the node enters the scene tree for the first time.
func _ready():
	print(map_width, map_height)
	rng.randomize()
	map.x = map_width
	map.y = map_height 
	print(map.x, " " , map.y)
	make_noise(noise_density)
	place_tiles(noise_grid)

func make_noise(density):
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
	print(noise_grid)

func place_tiles(grid):
	for i in map.y:
		for j in map.x:
			tiles.set_cell(0, Vector2i(j,i),grid[i][j],Vector2i(0,0))
	
