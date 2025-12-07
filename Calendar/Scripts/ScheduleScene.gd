extends Control

@onready var schedule_text = $ScheduleText
@onready var class_list = $ClassList
@onready var date_label = $HBoxContainer/DateLabel
@onready var coins_label = $HBoxContainer/CoinsLabel
@onready var coin_icon = $HBoxContainer/TextureRect

@onready var popup = $CoursePopup
@onready var popup_title = $CoursePopup/MarginContainer/VBoxContainer/PopupTitle
@onready var popup_info = $CoursePopup/MarginContainer/VBoxContainer/PopupInfo
@onready var popup_close = $CoursePopup/MarginContainer/VBoxContainer/CloseButton

const SAVE_DIR := "user://SavedCourses"
var pressed_today: Dictionary = {}
var current_day := 0


func _ready():
	schedule_text.visible = false
	# hide popup at startup (restoring original behavior)
	popup.hide()

	# coin system hookup
	Utils.connect("coins_changed", _on_coins_changed)
	_on_coins_changed(Utils.savedItems.coins)

	var saved_courses = []
	var dir = DirAccess.open(SAVE_DIR)
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if not dir.current_is_dir():
				var path = SAVE_DIR + "/" + filename
				var res = ResourceLoader.load(path)
				if res:
					saved_courses.append(res)
			filename = dir.get_next()
		dir.list_dir_end()

	for c in saved_courses:
		for i in range(c.weekdays.size()):
			c.weekdays[i] -= 1

	# FORCE MONDAY (for testing)
	current_day = 1

	var names = {
		0: "Sunday",
		1: "Monday",
		2: "Tuesday",
		3: "Wednesday",
		4: "Thursday",
		5: "Friday",
		6: "Saturday"
	}

	date_label.text = "Classes for %s" % names[current_day]

	for child in class_list.get_children():
		child.queue_free()

	if saved_courses.is_empty():
		return

	# build class rows (unchanged behavior)
	for c in saved_courses:
		if current_day in c.weekdays:
			var row := HBoxContainer.new()

			var cb := CheckBox.new()
			cb.text = ""
			var key = "%s-%s" % [c.title, str(current_day)]

			if pressed_today.has(key) and pressed_today[key]:
				cb.disabled = true
				cb.button_pressed = true

			cb.toggled.connect(func(on):
				if on:
					Utils.add_coins(1)
					pressed_today[key] = true
					cb.disabled = true
			)
			row.add_child(cb)

			var btn := Button.new()
			btn.text = c.title
			btn.focus_mode = Control.FOCUS_NONE
			btn.set_meta("course", c)
			btn.pressed.connect(_on_course_clicked.bind(btn))
			row.add_child(btn)

			class_list.add_child(row)
		else:
			# unchanged: no classes displayed for this course on non-matching days
			pass

	popup_close.pressed.connect(func(): popup.hide())


func readable_weekdays(weekdays):
	var map = {
		Time.Weekday.WEEKDAY_MONDAY: "Mon",
		Time.Weekday.WEEKDAY_TUESDAY: "Tue",
		Time.Weekday.WEEKDAY_WEDNESDAY: "Wed",
		Time.Weekday.WEEKDAY_THURSDAY: "Thu",
		Time.Weekday.WEEKDAY_FRIDAY: "Fri"
	}
	var list = []
	for w in weekdays:
		if map.has(w):
			list.append(map[w])
	return " / ".join(list)


func _on_course_clicked(button):
	var c = button.get_meta("course")
	var days = readable_weekdays(c.weekdays)

	popup_title.text = c.title
	popup_info.text = """
[b]Days:[/b]        %s
[b]Time:[/b]        %s – %s

[b]Start Date:[/b]  %s
[b]End Date:[/b]    %s
""" % [
		days,
		c.start_time,
		c.end_time,
		c.start_date,
		c.end_date
	]

	popup.show()


# ONLY the coin label changes — nothing else!
func _on_coins_changed(amount: int):
	coins_label.text = str(amount)
