extends Timer
class_name Cooldown

static func createCooldown(seconds:float) -> Timer:
	var newTimer = Timer.new()
	newTimer.wait_time = seconds
	newTimer.stop()
	newTimer.one_shot = true
	return newTimer
