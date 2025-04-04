extends Control

var sprite2d:Sprite2D :
	set(value):
		sprite2d = value
		%Texture.texture = sprite2d.texture
var layer_name:String :
	set(value):
		layer_name = value
		%Name.text = layer_name

signal up_pressed(layer)
signal down_pressed(layer)


func _on_up_pressed() -> void:
	up_pressed.emit(self)
func _on_down_pressed() -> void:
	down_pressed.emit(self)
