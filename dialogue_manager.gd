extends Node

signal dialogue_finished

@onready var ui_panel = $DialogueUI/Panel

@onready var npc_name_label = $DialogueUI/Panel/NpcName

@onready var npc_text_label = $DialogueUI/Panel/NpcText

@onready var player_text_label = $DialogueUI/Panel/PlayerText

var dialogue_lines = []
var index = 0
var talking = false

func _ready():

	get_tree().connect("current_scene_changed", Callable(self, "_find_ui"))

func _find_ui():
	var root = get_tree().get_current_scene()
	if !root:
		return
	if root.has_node("DialogueUI/Panel"):
		ui_panel = root.get_node("DialogueUI/Panel")

		npc_name_label = ui_panel.get_node("NpcName")

		npc_text_label = ui_panel.get_node("NpcText")

		player_text_label = ui_panel.get_node("PlayerText")

		print("✅ Dialogue UI linked successfully!")

	else:

		print("❌ DialogueUI/Panel not found in ", root.name)







func start_dialogue(npc_name: String, lines: Array):

	dialogue_lines = lines

	index = 0

	talking = true

	ui_panel.visible = true

	npc_name_label.text = npc_name

	_show_line()



func _show_line():

	var line = dialogue_lines[index]


	if line.has("npc"):

		npc_text_label.visible = true

		npc_text_label.text = line["npc"]

	else:

		npc_text_label.visible = false


	if line.has("player"):

		player_text_label.visible = true

		player_text_label.text = line["player"]

	else:

		player_text_label.visible = false



func next():

	if !talking:

		return


	index += 1

	if index >= dialogue_lines.size():

		end_dialogue()

		return


	_show_line()



func end_dialogue():

	ui_panel.visible = false

	talking = false

	emit_signal("dialogue_finished")
