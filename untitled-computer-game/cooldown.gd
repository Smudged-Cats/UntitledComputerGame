extends Timer

#Try and make cooldown more of a class that creates a "Cooldown"
# object, as opposed to its current state of being a sort of
# library with one funciton
class_name Cooldown

#CreateCooldown is an easier way to create a timer that
# acts like a cooldown between attacks
static func createCooldown(seconds:float) -> Timer:
	var newTimer = Timer.new()
	newTimer.wait_time = seconds
	newTimer.stop()
	newTimer.one_shot = true
	return newTimer
