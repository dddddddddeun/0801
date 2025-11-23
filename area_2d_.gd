extends Area2D

@onready var label = $Label

func _ready():
	$Label.visible = false
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		label.visible = false
