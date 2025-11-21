extends Node

# -------------------------
# Signals
# -------------------------
signal quest_added(id: String)
signal quest_started(id: String)
signal quest_completed(id: String)
signal quests_loaded()

# -------------------------
# Quest 데이터 저장
# quests = {
#   "quest_id": {
#       "name": String,
#       "desc": String,
#       "status": "not_started" | "in_progress" | "completed"
#   }
# }
# -------------------------
var quests: Dictionary = {}

# 자동 저장 설정
var autosave := true
var save_path := "user://quests.save"


# --------------------------------------------------------
# READY → 게임 시작 시 자동으로 이전 세이브 불러오기
# --------------------------------------------------------
func _ready() -> void:
	load()


# --------------------------------------------------------
# 퀘스트 추가
# --------------------------------------------------------
func add_quest(id: String, name: String, desc: String = "") -> void:
	if quests.has(id):
		push_warning("Quest already exists: %s" % id)
		return
	
	quests[id] = {
		"name": name,
		"desc": desc,
		"status": "not_started"
	}

	emit_signal("quest_added", id)
	if autosave:
		save()


# --------------------------------------------------------
# 퀘스트 시작
# --------------------------------------------------------
func start_quest(id: String) -> void:
	if not quests.has(id):
		push_error("start_quest: Unknown quest ID: %s" % id)
		return
	
	var q = quests[id]

	if q["status"] == "not_started":
		q["status"] = "in_progress"
		quests[id] = q

		emit_signal("quest_started", id)
		
		if autosave:
			save()


# --------------------------------------------------------
# 퀘스트 완료
# --------------------------------------------------------
func complete_quest(id: String) -> void:
	if not quests.has(id):
		push_error("complete_quest: Unknown quest ID: %s" % id)
		return
	
	var q = quests[id]

	if q["status"] != "completed":
		q["status"] = "completed"
		quests[id] = q

		emit_signal("quest_completed", id)
		
		if autosave:
			save()


# --------------------------------------------------------
# 상태 체크 함수들
# --------------------------------------------------------
func is_started(id: String) -> bool:
	if not quests.has(id):
		return false
	return quests[id]["status"] in ["in_progress", "completed"]


func is_completed(id: String) -> bool:
	if not quests.has(id):
		return false
	return quests[id]["status"] == "completed"


# --------------------------------------------------------
# 모든 퀘스트가 완료되었는지 체크
# DAY 완료 조건
# --------------------------------------------------------
func all_quests_completed() -> bool:
	for id in quests.keys():
		if quests[id]["status"] != "completed":
			return false
	return true


# --------------------------------------------------------
# 전체 퀘스트 가져오기
# --------------------------------------------------------
func get_quest(id: String) -> Dictionary:
	if not quests.has(id):
		return {}
	return quests[id]


func get_all_quests() -> Dictionary:
	return quests.duplicate(true)


# --------------------------------------------------------
# 저장/로드
# --------------------------------------------------------
func save(path: String = "") -> void:
	var p = path if path != "" else save_path
	var file = FileAccess.open(p, FileAccess.WRITE)
	if file == null:
		push_error("QuestManager.save: cannot open file %s" % p)
		return
	
	var data = { "quests": quests }
	var json = JSON.stringify(data)
	file.store_string(json)
	file.close()


func load(path: String = "") -> void:
	var p = path if path != "" else save_path

	if not FileAccess.file_exists(p):
		return  # 저장 파일 없음 → 무시

	var file = FileAccess.open(p, FileAccess.READ)
	if file == null:
		push_error("QuestManager.load: cannot open file %s" % p)
		return

	var text = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if parsed.error != OK:
		push_error("QuestManager.load: JSON 파싱 오류")
		return

	var data = parsed.result
	if typeof(data) == TYPE_DICTIONARY and data.has("quests"):
		quests = data["quests"].duplicate(true)
		emit_signal("quests_loaded")
