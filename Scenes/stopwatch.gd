extends Node
class_name Stopwatch
var time = 0.0
var stopped = true

func _process(delta: float) -> void:
	if stopped:
		return
	time += delta
	
func reset():
	time = 0.0
	
func time_to_string() -> String:
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var format_string = "%2d.%2d" + "sec"
	var actual_string = format_string % [sec, msec]
	return actual_string
