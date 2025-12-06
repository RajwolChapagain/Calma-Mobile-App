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

	var courses = ScheduleParser.get_courses(raw)
	# Fix weekday indexing mismatch from parser
	for c in courses:
		for i in range(c.weekdays.size()):
			c.weekdays[i] = c.weekdays[i] - 1


	var today = Time.get_datetime_dict_from_system().weekday
	print("TODAY =", today)
	for c in courses:
		print(c.title, "weekdays:", c.weekdays)

	if today > Time.Weekday.WEEKDAY_FRIDAY:
		today = Time.Weekday.WEEKDAY_MONDAY


	var names = {
	0: "Monday",
	1: "Tuesday",
	2: "Wednesday",
	3: "Thursday",
	4: "Friday",
	5: "Saturday",
	6: "Sunday"
}
	date_label.text = "Classes for " + names[today]

	for child in class_list.get_children():
		child.queue_free()

	for c in courses:
		if today in c.weekdays:
			var row := HBoxContainer.new()

			var cb := CheckBox.new()
			cb.text = ""   # no text next to the checkbox
			row.add_child(cb)

			var btn := Button.new()
			btn.text = c.title
			btn.focus_mode = Control.FOCUS_NONE
			btn.set_meta("course", c)
			btn.pressed.connect(_on_course_clicked.bind(btn))
			row.add_child(btn)

			class_list.add_child(row)



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

	popup.popup_centered()
	popup.show()
