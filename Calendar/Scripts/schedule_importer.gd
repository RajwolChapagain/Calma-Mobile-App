class_name ScheduleImporter extends Control

@export_dir var SAVED_COURSES_DIRECTORY: String
	
func _on_popup_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%ImportPanel.visible = true
	else:
		%ImportPanel.visible = false

func _on_import_button_pressed() -> void:
	save_courses_to_disk(ScheduleParser.get_courses(%ScheduleEntryTextField.text))
	%ScheduleEntryTextField.clear()
	%PopupButton.button_pressed = false
	_on_popup_button_toggled(%PopupButton.button_pressed)
	
func save_courses_to_disk(courses: Array[Course]) -> void:
	for course in courses:
		ResourceSaver.save(course, SAVED_COURSES_DIRECTORY + '/' + course.title + '.tres')
