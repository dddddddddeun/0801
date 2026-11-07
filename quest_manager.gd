extends Node

signal quest_added(id: String)
signal quest_started(id: String)
signal quest_completed(id: String)
signal quests_loaded()

func load_day_quests(resource_path: String):
	var script = load(resource_path)
	if script == null:
		push_error("❌ day quests 파일 로드 실패: " + resource_path)
		return

	var instance = script.new()

	if not instance.has_variable("quests"):
		push_error("❌ day quests 파일에 quests 변수가 없음")
		return

	var quest_array = instance.quests

	for q in quest_array:
		QuestManager.add_quest(q["id"], q["name"], q["desc"])

	print("📌 Day quests 로드 완료:", quest_array.size())

var quests: Dictionary = {}



func _ready() -> void:
	load_quests()


# ----------------------
# 퀘스트 추가
# ----------------------
func add_quest(id: String, name: String, desc: String = "") -> void:
	if quests.has(id):
		return

	quests[id] = {
		"name": name,
		"desc": desc,
		"status": "not_started"
	}

	emit_signal("quest_added", id)



# ----------------------
# 퀘스트 시작
# ----------------------
func start_quest(id: String) -> void:
	if not quests.has(id):
		return

	var q: Dictionary = quests[id]

	if q["status"] == "not_started":
		q["status"] = "in_progress"
		quests[id] = q
		print(q["status"])
		emit_signal("quest_started", id)



# ----------------------
# 퀘스트 완료
# ----------------------
func complete_quest(id: String) -> void:
	print("완료 함수 호출됨: ", id)
	if not quests.has(id):
		return

	var q: Dictionary = quests[id]

	if q["status"] != "completed":
		print("completed으로 바뀜")
		q["status"] = "completed"
		quests[id] = q
		emit_signal("quest_completed", id)



# ----------------------
# 조회 함수들
# ----------------------
func is_completed(id: String) -> bool:
	return quests.has(id) and quests[id]["status"] == "completed"


func get_all_quests() -> Dictionary:
	return quests.duplicate(true)


# ----------------------
# 저장
# ----------------------
func all_quests_completed() -> bool:
	for id in quests.keys():
		if quests[id]["status"] != "completed":
			return false
	return true


# ----------------------
# 로드
# ----------------------
func load_quests(path: String = "") -> void:
	var p: String = path 

	if not FileAccess.file_exists(p):
		return

	var file := FileAccess.open(p, FileAccess.READ)
	if file == null:
		return

	var text: String = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)

	if typeof(parsed) != TYPE_DICTIONARY:
		return

	if parsed.has("quests"):
		quests = parsed["quests"]
	else:
		quests = {}

	emit_signal("quests_loaded")
