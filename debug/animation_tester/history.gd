extends Node

@onready var animation_tester = find_parent("Animation Tester")
enum {
	POSITION,
	ROTATION,
	SCALE
}

var past = []
var future = []

func add_action(type:int, args:Array):
	var result:Array
	for i in range(past.size() - 1):
		var inverse_i = past.size() - 1 - i
		if past[inverse_i][0] == type and past[inverse_i][1] == args[0] and past[inverse_i][2] == args[1]:
			print('nothing happened')
			return
	match type:
		POSITION:
			# args = [sprite, position]
			result = [type, args[0], args[1]]
		ROTATION:
			# args = [sprite, rotation_degrees]
			result = [type, args[0], args[1]]
		SCALE:
			# args = [sprite, scale]
			result = [type, args[0], args[1]]
	past.append(result)
	#print(past)
	future = []

func undo():
	
	var cur_action = past[past.size() - 1]
	future.append(cur_action)
	var action:Array = []
	for i in range(past.size() - 1):
		var inverse_i = past.size() - 2 - i
		if past[inverse_i][0] == cur_action[0] and past[inverse_i][1] == cur_action[1]:
			action = past[inverse_i]
			break
	if action == []:
		printerr("Could not undo!")
		return
	past.pop_back()
	#print(action)
	match action[0]:
		POSITION:
			action[1].position = action[2]
		ROTATION:
			action[1].rotation_degrees = action[2]
		SCALE:
			action[1].scale = action[2]
	
	animation_tester.update_selection(action[1])
