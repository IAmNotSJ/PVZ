class_name Plants
extends Node

	#["walnut", "res://assets/plants/walnut/walnut.tscn"],
	#["potato_mine", "res://assets/plants/potato_mine/potato_mine.tscn"],
	#["snow_pea", "res://assets/plants/snow_pea/snow_pea.tscn"],
	#["cherry_bomb", "res://assets/plants/cherry_bomb/cherry_bomb.tscn"],
	#["chomper", "res://assets/plants/chomper/chomper.tscn"],
	#["beatroot", "res://assets/plants/beatroot/beatroot.tscn"]

#var plantPrices:Array = [
	#100, 50, 50, 25, 150, 150, 125, 125
#]

static var plants:Dictionary = {
	"peashooter" : {
		"Path" : "res://assets/plants/peashooter/peashooter.tscn",
		"Price" : 100
	},
	"sunflower" : {
		"Path" : "res://assets/plants/sunflower/sunflower.tscn",
		"Price" : 50
	},
	"walnut" : {
		"Path" : "res://assets/plants/walnut/walnut.tscn",
		"Price" : 50
	},
	"potato_mine" : {
		"Path" : "res://assets/plants/potato_mine/potato_mine.tscn",
		"Price" : 25
	},
	"snow_pea" : {
		"Path" : "res://assets/plants/snow_pea/snow_pea.tscn",
		"Price" : 150
	},
	"cherry_bomb" : {
		"Path" : "res://assets/plants/cherry_bomb/cherry_bomb.tscn",
		"Price" : 150
	},
	"chomper" : {
		"Path" : "res://assets/plants/chomper/chomper.tscn",
		"Price": 125
	},
	"beatroot" : {
		"Path" : "res://assets/plants/beatroot/beatroot.tscn",
		"Price" : 125
	},
	"repeater" : {
		"Path" : "res://assets/plants/repeater/repeater.tscn",
		"Price" : 200
	}
}
