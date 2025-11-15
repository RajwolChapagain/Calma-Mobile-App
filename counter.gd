extends Label

var count:int = 0

func _input(event):
	if event.is_action_pressed("count"):
		count += 1
		text = str(count)
