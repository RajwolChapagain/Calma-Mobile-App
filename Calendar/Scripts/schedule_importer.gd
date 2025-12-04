class_name ScheduleImporter extends Control

const SAVE_DIRECTORY_NAME: String = 'SavedCourses'

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
	var save_directory = 'user://%s' % SAVE_DIRECTORY_NAME
	if not DirAccess.dir_exists_absolute(save_directory):
		DirAccess.make_dir_absolute(save_directory)

	for course in courses:
		ResourceSaver.save(course, save_directory + '/' + course.title + '.tres')
