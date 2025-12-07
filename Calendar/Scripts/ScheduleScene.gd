extends Control

@onready var schedule_text = $ScheduleText
@onready var class_list = $ClassList
@onready var date_label = $DateLabel
@onready var current_time_label = $CurrentTimeLabel

@onready var popup = $CoursePopup
@onready var popup_title = $CoursePopup/VBoxContainer/PopupTitle
@onready var popup_info = $CoursePopup/VBoxContainer/PopupInfo
@onready var popup_close = $CoursePopup/VBoxContainer/CloseButton


func _ready():
	var raw = schedule_text.text
	schedule_text.visible = false

	var saved_courses_dir = 'user://%s' % ScheduleImporter.SAVE_DIRECTORY_NAME
	var courses = []
	var save_dir = 'user://' + ScheduleImporter.SAVE_DIRECTORY_NAME

	for item in ResourceLoader.list_directory(save_dir):
		var resource = ResourceLoader.load(save_dir + '/' + item)
		courses.append(resource)

	for c in courses:
		for i in range(c.weekdays.size()):
			c.weekdays[i] = c.weekdays[i] - 1

	var today = Time.get_datetime_dict_from_system().weekday

	var names = {
		0: "Sunday",
		1: "Monday",
		2: "Tuesday",
		3: "Wednesday",
		4: "Thursday",
		5: "Friday",
		6: "Saturday"
	}
	date_label.text = "Classes for " + names[today]

	for child in class_list.get_children():
		child.queue_free()

	var found_any = false

	for c in courses:
		if today in c.weekdays:
			found_any = true

			var row := HBoxContainer.new()

			var cb := CheckBox.new()
			cb.text = ""

			var weekday_key := str(today)
			var unique_key := "user://checked_%s_%s.save" % [c.title, weekday_key]

			if FileAccess.file_exists(unique_key):
				var f = FileAccess.open(unique_key, FileAccess.READ)
				var stored = f.get_var()
				f.close()
				if stored:
					cb.button_pressed = true
					cb.disabled = true

			cb.pressed.connect(_on_checkbox_pressed.bind(cb, unique_key))
			row.add_child(cb)

			var btn := Button.new()
			btn.text = c.title
			btn.focus_mode = Control.FOCUS_NONE
			btn.set_meta("course", c)
			btn.pressed.connect(_on_course_clicked.bind(btn))
			row.add_child(btn)

			class_list.add_child(row)

	if not found_any:
		var label := Label.new()
		label.text = "No Classes Today"
		label.add_theme_color_override("font_color", Color(1, 0.5, 0.5))
		label.add_theme_font_size_override("font_size", 22)
		class_list.add_child(label)

	popup_close.pressed.connect(func(): popup.hide())


func _on_checkbox_pressed(cb: CheckBox, key: String):
	cb.button_pressed = true
	cb.disabled = true
	var f = FileAccess.open(key, FileAccess.WRITE)
	f.store_var(true)
	f.close()


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

	popup.popup_centered()
	popup.show()
