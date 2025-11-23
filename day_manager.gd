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
		push_error("❌ DayManager: 잘못된 day 번호: %s" % new_day)
		return

	current_day = new_day

	# 1) 퀘스트 초기화 + 새 day의 퀘스트 로드
	_load_day_quests(current_day)

	# 2) day의 메인 씬 로드
	_load_day_scene(current_day)

	emit_signal("day_changed", current_day)
	print("Day changed →", current_day)


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
func next_day():
	if current_day >= max_day:
		print("마지막 Day입니다.")
		return

	current_day += 1

	print("Next Day →", current_day)

	# 안전하게 day 변경
	call_deferred("_deferred_change_day")
	

func _deferred_change_day():
	change_day(current_day)


# ==========================================================
# Day별 퀘스트 로드
# ==========================================================
func _load_day_quests(day: int):
	if not day_quests.has(day):
		push_error("❌ DayManager: day_quests에 %s 없음" % day)
		return

	var res_path = day_quests[day]
	var res = load(res_path)

	if res == null:
		push_error("❌ DayManager: 퀘스트 파일 로드 실패: %s" % res_path)
		return


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
