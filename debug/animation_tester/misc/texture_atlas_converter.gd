extends Node

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# THIS IS BASED OFF OF THIS PLUGIN FOR GODOT; I JUST KINDA MODIFIED IT TO FIT IN HERE   #
#                              ORIGINALLY MADE BY KAUTARUMA                             #
#                    https://github.com/KAUTARUMA/godot-texture-atlas                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

const NAMES = {
	"ANIMATION": "AN",
	"SYMBOL_DICTIONARY": "SD",
	"TIMELINE": "TL",
	"LAYERS": "L",
	"Frames": "FR",
	"Symbols": "S",
	"name": "N",
	"SYMBOL_name": "SN",
	"elements": "E",
	"Layer_name": "LN",
	"index": "I",
	"duration": "DU",
	"ATLAS_SPRITE_instance": "ASI",
	"Instance_Name": "IN",
	"symbolType": "ST",
	"movieclip": "MC",
	"graphic": "G",
	"firstFrame": "FF",
	"loop": "LP",
	"Matrix3D": "M3D",
	"metadata": "MD",
	"framerate": "FRT",
	"SYMBOL_Instance" : "SI",
}



func _ready():
	var anim_json = load("res://debug/animation_tester/misc/texture_atlas_converter/test/extradance/Animation.json")
	var spritemap_json = load("res://debug/animation_tester/misc/texture_atlas_converter/test/extradance/spritemap1.json")
	#print(anim_json.data)
	#print(spritemap_json.data)
	_load_atlas(anim_json, spritemap_json)

func _load_atlas(anim_json:JSON, spritemap_json:JSON):
	
	var is_optimized:bool = false
	if anim_json.data.has(NAMES["ANIMATION"]):
		is_optimized = true
	
	var info:Dictionary = {
		"Framrate" : anim_json.data[NAMES["metadata"]][NAMES["framerate"]]
	}
	
	var symbols:Dictionary[String, Array] = {}
	var rects:Dictionary[String, Rect2i] = {}
	var frames:Dictionary[String, Dictionary] = {}
	
	
	var sprites = []
	for sprite in spritemap_json.data["ATLAS"]["SPRITES"]:
		var sprite_info = sprite["SPRITE"]
		rects[sprite_info["name"]] = Rect2i(
			int(sprite_info["x"]), 
			int(sprite_info["y"]), 
			int(sprite_info["w"]), 
			int(sprite_info["h"])
			)
	
	var limbs
	
	for symbol_data in anim_json.data[NAMES["SYMBOL_DICTIONARY"]][NAMES["Symbols"]]:
		symbols[symbol_data[NAMES["SYMBOL_name"]]] = symbol_data[NAMES["TIMELINE"]][NAMES["LAYERS"]]
	symbols["_top"] = anim_json.data[NAMES["ANIMATION"]][NAMES["TIMELINE"]][NAMES["LAYERS"]]
	
	
	var recursive_symbols:Array[String] = []
	for symbol in symbols.keys():
		frames[symbol] = {}
		var recursive_symbol:bool = true
		if symbol != "_top":
			var layers_array = symbols[symbol]
			for layer in layers_array:
				for frame in layer[NAMES["Frames"]]:
					frames[symbol] 
					for element in frame[NAMES["elements"]]:
						if !element.has(NAMES["SYMBOL_Instance"]):
							recursive_symbol = false
		if !recursive_symbol:
			var new_symbol = Sprite2D.new()
			new_symbol.name = symbol
			frames[symbol]["Symbol"] = new_symbol
	print(frames)
	#	print(frames)
		#for layer in symbols[symbol]:
			#for frame in layer[NAMES["Frames"]]:
				#for element in frame[NAMES["elements"]]:
					#match element.keys()[0]:
						#NAMES["ATLAS_SPRITE_instance"]:
							#frames[element[NAMES["ATLAS_SPRITE_instance"]][NAMES["name"]]] = {
								#"Transform2D" : m3d_to_transform2d(element[NAMES["ATLAS_SPRITE_instance"]][NAMES["Matrix3D"]], is_optimized)
							#}
						#NAMES["SYMBOL_Instance"]:
							#frames[element[NAMES["SYMBOL_Instance"]][NAMES["SYMBOL_name"]]] = {
								#"Transform2D" : m3d_to_transform2d(element[NAMES["SYMBOL_Instance"]][NAMES["Matrix3D"]], is_optimized)
							#}

func m3d_to_transform2d(matrix, is_optimized) -> Transform2D:
	var x_axis:Vector2
	var y_axis:Vector2
	var translation:Vector2
	
	if is_optimized:
		x_axis = Vector2(matrix[0], matrix[1])
		y_axis = Vector2(matrix[4], matrix[5])
		translation = Vector2(matrix[12], matrix[13])
	else:
		x_axis = Vector2(matrix["m00"], matrix["m01"])
		y_axis = Vector2(matrix["m10"], matrix["m11"])
		translation = Vector2(matrix["m30"], matrix["m31"])

	return Transform2D(x_axis, y_axis, translation)
