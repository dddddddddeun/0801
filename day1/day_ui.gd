extends CanvasLayer

@onready var label = $Panel/DayLabel


func _ready():
	DayManager.day_changed.connect(_on_day_changed)
	_on_day_changed(DayManager.current_day)


func _on_day_changed(day):
	label.text = "Day " + str(day)
