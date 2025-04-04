class_name FallingObject
extends Node2D

const prop_scene:PackedScene = preload("res://assets/objects/zombie_hats/falling/falling_object.tscn")

static func create(object, global_pos):
	var prop = prop_scene.instantiate()
	if object.get_parent() == null:
		prop.get_node('base').add_child(object)
	else:
		object.reparent(prop.get_node('base'))
	prop.get_node('anim').play('fall')
	prop.global_position = global_pos
	global.mainScene.add_child(prop)
 
