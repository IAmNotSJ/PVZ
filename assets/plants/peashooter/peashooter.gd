extends Plant
class_name PeaShooter

enum TYPE {
	NORMAL,
	SNOW,
	FIRE
}

@export var shootingType:TYPE = TYPE.NORMAL

@export var maxShootingTimer:int = 2
@export var sight:Area2D
@export var marker:Marker2D

@export var shootingPlayer:AnimationPlayer

var shootingTimer:float = maxShootingTimer
var can_shoot:bool = false

var peaScene = preload("res://assets/objects/peas/normal/pea.tscn")


func activate():
	super()
	var collision_shape = sight.get_children()[0]
	var tilemap = global.mainScene.tilemap
	
	# global position of the tilemap, plus its current tile + 1 to reach the end of the tile, times the width of the tile
	var tile_position_x = tilemap.global_position.x + (curTile.x * tilemap.cell_quadrant_size)
	var sight_offset = tilemap.cell_quadrant_size - (sight.global_position.x - tile_position_x)
	
	# gridSize starts counting at 1, while curTile starts counting at 0
	collision_shape.shape.size.x = (tilemap.gridSize.x - (curTile.x + 1)) * tilemap.cell_quadrant_size + sight_offset
	collision_shape.shape.size.x /= scale.x
	collision_shape.position.x = collision_shape.shape.size.x / 2
func _process(delta):
	can_shoot = false
	if (sight.has_overlapping_areas()):
		can_shoot = true
	if activated:
		shootingTimer -= delta
		if can_shoot:
			if shootingTimer <= 0:
				shootingTimer = maxShootingTimer
				shootingPlayer.play("shoot")

func shoot():
	var pea = peaScene.instantiate()
	pea.change_type(shootingType)
	global.mainScene.add_child(pea)
	pea.global_position = marker.global_position
