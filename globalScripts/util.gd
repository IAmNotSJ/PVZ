class_name Util extends Node

static func is_between(val:float, minmax:Vector2) -> bool:
	if val >= minmax.x and val <= minmax.y:
		return true
	else:
		return false
