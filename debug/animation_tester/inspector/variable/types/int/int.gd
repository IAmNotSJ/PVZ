extends SpinBox

signal new_value(val)

const RATIO_INSTANCES = ["scale"]

func _on_value_changed(val: float) -> void:
	new_value.emit(val)
