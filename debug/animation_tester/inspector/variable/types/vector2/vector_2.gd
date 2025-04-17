extends Control

signal new_value(value)

var value : Vector2 : 
	get():
		return Vector2($x.value, $y.value)
	set(val):
		value = val
		$x.value = val.x
		$y.value = val.y

@onready var boxes = [$x, $y]

func _ready():
	for box in boxes:
		box.value_changed.connect(_on_value_changed)

func _on_value_changed(_val):
	var result:Vector2 = Vector2($x.value, $y.value)
	new_value.emit(result)
