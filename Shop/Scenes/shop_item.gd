extends Button
class_name ShopItem

@export var cost:int = 1
#@export var incon: Texture2D
@export var bought: bool = false
@export var item_name: String = "Unnamed"
@export var equiped: bool = false

@export var desc: String = "No Description":
	set(value):
		$CanvasLayer/CenterContainer/ToolTip/MarginContainer/Description.text = value
		desc = value

#Pressing button only brings up tool tip
