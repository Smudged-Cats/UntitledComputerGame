extends Node
class_name Cooldown

var newTimer: Timer = Timer.new()

func _init(waitTime:float):
	newTimer.wait_time = waitTime
	newTimer.one_shot = true
	newTimer.stop()
	add_child(newTimer)

func startTimer() -> void:
	newTimer.start()

func timeLeft() -> float:
	return newTimer.time_left

func setWaitTime(seconds:float) -> void:
	newTimer.wait_time = seconds
	
func getWaitTime() -> float:
	return newTimer.wait_time
