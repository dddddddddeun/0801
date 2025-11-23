extends Label

func _ready():
	text = "Day " + str(DayManager.current_day)
