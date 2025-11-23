extends Node

var current_day := 1
var max_day := 3

var day_main_scene := {
	1: "res://day1/day1_scene_1.tscn",
	#2: "res://days/day2_scene_1.tscn",
	#3: "res://days/day3_scene_1.tscn"
}

func _ready() -> void:
	# ❗ 자동 로드 금지
	# _load_day_scene(current_day)
	pass

# ======================================================
# Day 변경
# ======================================================
func change_day(new_day: int) -> void:
	if new_day < 1 or new_day > max_day:
		push_error("DayManager: 잘못된 day: %s" % new_day)
		return

	current_day = new_day

	# 새 day의 메인씬 로드
	_load_day_scene(current_day)

	# 모든 퀘스트 초기화 후 다시 등록

	emit_signal("day_changed", current_day)
	print("Day changed →", current_day)


# ======================================================
# 다음 Day로 넘어가기
# ======================================================
func next_day() -> void:
	if current_day >= max_day:
		print("마지막 Day입니다.")
		return

	current_day += 1

	# 씬 로드
	_load_day_scene(current_day)

	# 퀘스트 초기화 + 재등록

	emit_signal("day_changed", current_day)
	print("Next Day →", current_day)


# ======================================================
# Day의 메인 씬 불러오기
# ======================================================
func _load_day_scene(day: int) -> void:
	if not day_main_scene.has(day):
		push_error("DayManager: day_main_scene에 %s가 없음" % day)
		return

	var path = day_main_scene[day]
	var scene = load(path)

	if scene == null:
		push_error("DayManager: 씬 로드 실패: %s" % path)
		return

	get_tree().change_scene_to_packed(scene)
