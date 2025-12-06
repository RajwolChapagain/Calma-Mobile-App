# Course.gd
class_name Course
extends Resource   # or RefCounted, either is fine

var title: String
var start_date: String
var end_date: String
var weekdays: Array[Time.Weekday]
var start_time: String
var end_time: String

func _init(
		_title: String,
		_start_date: String,
		_end_date: String,
		_weekdays: Array[Time.Weekday],
		_start_time: String,
		_end_time: String
	) -> void:
	title = _title
	start_date = _start_date
	end_date = _end_date
	weekdays = _weekdays
	start_time = _start_time
	end_time = _end_time
