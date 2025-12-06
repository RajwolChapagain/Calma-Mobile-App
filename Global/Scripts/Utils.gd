extends Node

var gui_themes: Array = [load("res://Shop/Assets/Themes/PlaceHolderTestTheme.tres")]
const SAVE_PATH:String = "res://Global/TempSaves/Utils.tres"

var savedItems:SavedItems = SavedItems.new()
signal theme_switch(theme:Theme)

func _ready():
	if FileAccess.file_exists(SAVE_PATH):
		savedItems = ResourceLoader.load(SAVE_PATH)
	

func change_theme(theme: int):
	if theme < gui_themes.size():
		savedItems.active_gui = theme
		theme_switch.emit(gui_themes[savedItems.active_gui])

func save_utils():
	ResourceSaver.save(savedItems,SAVE_PATH)

func add_coins(num: int):
	savedItems.coins += num
