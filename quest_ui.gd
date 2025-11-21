extends Control

@onready var quest_list = $Panel/QuestList

func _ready():
	# QuestManager 신호 연결
	QuestManager.quest_added.connect(_on_quest_updated)
	QuestManager.quest_started.connect(_on_quest_updated)
	QuestManager.quest_completed.connect(_on_quest_updated)
	QuestManager.quests_loaded.connect(_on_quest_updated)

	# 첫 로딩 시 UI 갱신
	_update_ui()


func _on_quest_updated(id):
	_update_ui()


func _update_ui():
	quest_list.queue_free_children()

	var quests = QuestManager.get_all_quests()

	for id in quests.keys():
		var q = quests[id]

		var label = Label.new()
		var status = q["status"]

		if status == "not_started":
			continue  # UI에 표시 안함 (원하면 보여줄 수도 있음)

		if status == "completed":
			label.text = "🟢 " + q["name"]
			label.add_theme_color_override("font_color", Color.GRAY)

		quest_list.add_child(label)
