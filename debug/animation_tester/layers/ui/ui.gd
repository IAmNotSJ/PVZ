class_name LayerUI extends Control

@onready var base_button = %BaseButton
@onready var name_container = %NameContainer
@onready var button_container = %ButtonContainer

@onready var texture = %Texture
@onready var name_label = %Name

@onready var up_button = %up
@onready var down_button = %down
@onready var trash_button = %trash

@onready var inherited_size_nodes = [base_button, name_container, button_container]

var layer_name:String :
	set(value):
		layer_name = value
		%Name.text = layer_name
