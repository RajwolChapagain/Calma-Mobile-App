extends Button
class_name ShopItem


@export var toolTipIcon: TextureRect
@export var toolDescNode: RichTextLabel

@export var cost:int = 1
@export var shop_icon: Texture2D:
	set(value):
		icon = value
		if is_instance_valid(toolTipIcon):
			toolTipIcon.texture = value
		shop_icon = value
@export var bought: bool = false
@export var item_name: String = "Unnamed"
@export var equiped: bool = false



@export var desc: String = "No Description":
	set(value):
		if is_instance_valid(toolDescNode):
			toolDescNode.text = value
		desc = value

func _ready():
	toolTipIcon.texture = shop_icon
	icon = shop_icon
	toolDescNode.text = desc
#Pressing button only brings up tool tip



func _on_button_down():
	#emit some signal for button down to hide the other tool tips
	$CanvasLayer.visible = true

func _on_close_button_button_down():
	$CanvasLayer.visible = false
