extends Node

# ==========================================================
# Signals
# ==========================================================
signal day_changed(new_day)
signal ready_for_next_day

# ==========================================================
# Variables
# ==========================================================
var current_day: int = 1
var max_day: int = 3

# day → 메인 씬
var day_main_scene := {
	1: "res://day1/day1_scene_1.tscn",
	2: "res://day2/day2_scene_1.tscn",
	#3: "res://day3/day3_scene_1.tscn"
}

# day → 퀘스트 파일(Resource)
var day_quests := {
	1: "res://quests/day1_quests.gd",
	#2: "res://quests/day2_quests.gd",
	#3: "res://quests/day3_quests.gd"
}


# ==========================================================
# READY (자동 실행 X)
# ==========================================================
func _ready():
	# main.tscn에서 Start 버튼을 눌러야 day1이 시작됨
	pass


# ==========================================================
# Day 변경 메인 함수
# ==========================================================
func change_day(new_day: int) -> void:
	if new_day < 1 or new_day > max_day:
		push_error("잘못된 Day 번호: %s" % new_day)
		return

	# 이동하려는 날짜의 씬이 등록되어 있는지 확인
	if not day_main_scene.has(new_day):
		push_error("Day %s 씬이 등록되어 있지 않습니다." % new_day)
		return

	var scene_path: String = day_main_scene[new_day]

	# 실제 씬 파일을 불러오기
	var scene: PackedScene = load(scene_path) as PackedScene

	if scene == null:
		push_error("씬 로드 실패: " + scene_path)
		return

	# 씬 변경 시도
	var result: Error = get_tree().change_scene_to_packed(scene)

	if result != OK:
		push_error("씬 변경 실패! 오류 코드: %s" % result)
		return

	# 씬 변경 요청이 성공했을 때 날짜 변경
	current_day = new_day

	# 기존 퀘스트 목록 초기화
	QuestManager.quests.clear()

	# 해당 Day의 퀘스트 데이터 불러오기
	_load_day_quests(current_day)

	# 날짜 변경 신호
	day_changed.emit(current_day)

	print("✅ Day 변경 성공: ", current_day)
# ==========================================================
# 모든 퀘스트 완료 시 다음 Day로 이동 가능
# ==========================================================
func check_day_clear_condition():
	if QuestManager.all_quests_completed():
		print("모든 퀘스트 완료! → 다음 Day로 이동 가능")
		emit_signal("ready_for_next_day")


# ==========================================================
# 다음 Day로 이동
# ==========================================================
func next_day() -> void:
	if current_day >= max_day:
		print("마지막 Day입니다.")
		return

	var target_day: int = current_day + 1

	print("다음 날짜로 이동 요청: Day ", target_day)

	call_deferred("change_day", target_day)
	
func _deferred_change_day():
	change_day(current_day)


# ==========================================================
# Day별 퀘스트 로드
# ==========================================================
func _load_day_quests(day: int) -> void:
	if not day_quests.has(day):
		print("Day ", day, "에 등록된 퀘스트 파일이 없습니다.")
		return

	var res_path: String = day_quests[day]

	var script = load(res_path)

	if script == null:
		push_error("퀘스트 파일 로드 실패: " + res_path)
		return

	var instance = script.new()

	for q in instance.quests:
		QuestManager.add_quest(
			q["id"],
			q["name"],
			q["desc"]
		)

	print("✅ Day ", day, " 퀘스트 로드 완료")

# ==========================================================
# Day의 메인 씬 로드
# ==========================================================
func _load_day_scene(day: int):
	if not day_main_scene.has(day):
		push_error("❌ DayManager: day_main_scene에 %s 없음" % day)
		return

	var path = day_main_scene[day]
	var scene = load(path)

	if scene == null:
		push_error("❌ DayManager: 씬 로드 실패 %s" % path)
		return

	get_tree().change_scene_to_packed(scene)
	print("Day%s scene loaded!" % day)
