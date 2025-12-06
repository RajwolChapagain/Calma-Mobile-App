extends Control

func _ready():
	Utils.connect("theme_switch",change_theme)

func change_theme(t:Theme):
	theme = t
	print("test")
