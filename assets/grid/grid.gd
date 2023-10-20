extends TileMap

@export var curTile:Vector2

@onready var mainScene = get_tree().current_scene

var gridSize:Vector2i = Vector2i(9,5)
var dic = {}
var availability = {}

func _ready():
	for x in gridSize.x:
		for y in gridSize.y:
			dic[str(Vector2i(x,y))] = "Free"

func _process(_delta):
	var tile = local_to_map(mainScene.tilemap.get_local_mouse_position())
	curTile = tile
	
	for x in gridSize.x:
		for y in gridSize.y:
			erase_cell(0, Vector2i(x,y))
			erase_cell(1, Vector2i(x,y))
	
	if (mainScene.curHolding != null):
		if dic.has(str(tile)):
			for x in gridSize.x:
				if (x == tile.x):
					for y in gridSize.y:
						set_cell(0, Vector2(x, y), 2, Vector2i(0,0), 0)
			for y in gridSize.y:
				if (y == tile.y):
					for x in gridSize.x:
						set_cell(1, Vector2(x, y), 2, Vector2i(0,0), 0)
	
