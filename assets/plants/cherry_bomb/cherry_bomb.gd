extends Plant
class_name CherryBomb
@export var MAX_EXPLOSION_TIMER:float = 1
@export var explosion_area:Area2D

var explosion_timer = MAX_EXPLOSION_TIMER

func activate():
	$ShakePlayer.play('shake')
	
	set_explosion_area()
	
	super()

func explode():
	print('splodin')
	#$ExplosionRadius.collision_layer = 4
	if (explosion_area.has_overlapping_areas()):
		for i in explosion_area.get_overlapping_areas().size():
			explosion_area.get_overlapping_areas()[i].owner.take_damage(30, Enums.DAMAGE_EXPLOSION)
	remove_plant()

func set_explosion_area():
	var collision_shape = explosion_area.get_children()[0]
	var tilemap = global.mainScene.tilemap
	collision_shape.shape.size = Util.vector2s(tilemap.rendering_quadrant_size * 3)
	
	explosion_area.global_position = tilemap.global_position + curTile * Util.vector2s(tilemap.rendering_quadrant_size) + Util.vector2s(tilemap.rendering_quadrant_size) / Util.vector2s(2)
