extends TextureButton

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():

	get_tree().change_scene_to_file("res://day1/day1_scene_1.tscn")
	
	
