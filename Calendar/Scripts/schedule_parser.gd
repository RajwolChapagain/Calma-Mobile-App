class_name ScheduleParser

static func get_courses(schedule_text: String) -> Array[Course]:
	var parsed_courses: Array[Course] = []

	var course_line_follows = false
	for line in schedule_text.split('\n'):
		if course_line_follows and not line.strip_edges().is_empty():
			var course: Course = get_course_from_line(line)
			if course != null:
				parsed_courses.append(course)
			
		if line.begins_with('Course'):
			course_line_follows = true
		elif line.strip_edges().is_empty():
			course_line_follows = false
	
	return parsed_courses
	
static func get_course_from_line(line: String) -> Course:
	var items = line.split('\t')
	
	var days: String = items[7]
	# Some independent study classes don't have dates. We don't parse them
	if days.strip_edges().is_empty():
		return null
			
	var title: String = items[0]
	if title.ends_with('.'):
		title = title.get_slice('.', 0)
	var start_date: String = items[5]
	var end_date: String = items[6]
	var weekdays: Array[Time.Weekday] = []
	for day: String in items[7].split(' '):
		weekdays.append(get_weekday_from_char(day))
		if day not in ['M', 'T', 'W', 'R', 'F']:
			print(line)
			
	var start_time: String = items[8]
	var end_time: String = items[9]
	
	return Course.new(title, start_date, end_date, weekdays, start_time, end_time)

static func get_weekday_from_char(c: String) -> Time.Weekday:
	if c == 'M':
		return Time.Weekday.WEEKDAY_MONDAY
	elif c == 'T':
		return Time.Weekday.WEEKDAY_TUESDAY
	elif c == 'W':
		return Time.Weekday.WEEKDAY_WEDNESDAY
	elif c == 'R':
		return Time.Weekday.WEEKDAY_THURSDAY
	elif c == 'F':
		return Time.Weekday.WEEKDAY_FRIDAY
	else:
		printerr('Error: Class day outside range Monday-Friday')
		return Time.WEEKDAY_SATURDAY
