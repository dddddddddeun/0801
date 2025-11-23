extends CanvasLayer

var quest_list: VBoxContainer = null
var new_font: FontFile = load("res://ThinDungGeunMo.ttf")

func _ready():
	# 신호 연결(미리) — 퀘스트 변경시 UI 갱신
	QuestManager.quest_added.connect(_on_quest_changed)
	QuestManager.quest_started.connect(_on_quest_changed)
	QuestManager.quest_completed.connect(_on_quest_changed)
	QuestManager.quests_loaded.connect(_on_quest_changed)

	# 첫 프레임 기다렸다가 quest_list 찾고 갱신
	await get_tree().process_frame
	_find_list_node()
	_update_ui()


func _on_quest_changed(id = ""):
	# 디버깅 로그
	print("[QuestUI] quest changed signal:", id)
	_update_ui()


func _find_list_node():
	quest_list = null
	var root = get_tree().current_scene
	if root == null:
		print("[QuestUI] current_scene == null")
		return

	# 여러 구조 대응
	if root.has_node("PanelContainer/quest_list"):
		quest_list = root.get_node("PanelContainer/quest_list")
		print("[QuestUI] Loaded quest_list from PanelContainer/quest_list")
		return
	if root.has_node("Panel/QuestList"):
		quest_list = root.get_node("Panel/QuestList")
		print("[QuestUI] Loaded quest_list from Panel/QuestList")
		return
	# 혹시 Autoload로 등록한 QuestUI 씬 내부 자체에 quest_list가 있는 경우
	if has_node("Panel/QuestList"):
		quest_list = get_node("Panel/QuestList")
		print("[QuestUI] Loaded quest_list from own Panel/QuestList")
		return

	print("[QuestUI] ERROR: QuestList 노드를 찾지 못함")


func _update_ui():
	if quest_list == null:
		print("[QuestUI] update skipped — quest_list is NULL")
		return

	print("[QuestUI] Updating UI...")
	# 기존 항목 전부 삭제
	for child in quest_list.get_children():
		child.queue_free()

	var quests = QuestManager.get_all_quests()
	print("[QuestUI] quests:", quests)

	for id in quests.keys():
		var q = quests[id]
		var label := Label.new()
		label.name = id
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.tooltip_text = q.get("desc", "")

		# 상태별 폰트 색(강제)
		match q["status"]:
			"not_started":
				label.text = "  🔒 " + q["name"] 
				label.add_theme_color_override("font_color", Color(0.176, 0.176, 0.176))
				label.add_theme_font_override("font", new_font)

			"completed":
				label.text = "  ✅ " + q["name"] 
				label.add_theme_color_override("font_color", Color(0.1, 0.6, 0.1))
				label.add_theme_font_override("font", new_font)
				print("[QuestUI] 퀘스트 완료 표시됨:", id)

		quest_list.add_child(label)

	# 강제로 레이아웃 갱신(안정성)
	quest_list.queue_sort()
	quest_list.queue_redraw()
