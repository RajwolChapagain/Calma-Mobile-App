extends Node

class SavedItems:
	extends Resource
	@export var coins: int = 5
	@export var bought_guis: Array = []
	@export var bought_avatars: Array = []
	@export var active_gui: int = 0
	@export var active_avatar: int = 0
