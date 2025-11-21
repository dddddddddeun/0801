extends Node

var current_day := 1

# day별 씬 경로
var day_scenes := {
	1: "res://day1/day1_scene_2.tscn",
	#2: "res://days/day2.tscn",
	#3: "res://days/day3.tscn",
}

# day별 퀘스트 데이터 파일
var day_quests := {
	1: "res://quests/day1_quests.gd",
	#2: "res://quests/day2_quests.gd",
}

func _ready():
	load_day(current_day)


# ------------------------------
# DAY 불러오기
# ------------------------------
func load_day(day: int):
	current_day = day

	# 1) 먼저 퀘스트 초기화
	QuestManager.quests.clear()

	# 2) day에 해당하는 퀘스트 등록
	_register_day_quests(day)

	# 3) 씬 전환
	get_tree().change_scene_to_file(day_scenes[day])


func _register_day_quests(day: int):
	var path = day_quests[day]
	var script = load(path).new()

	# script.quests 는 Array로 되어 있음
	for q in script.quests:
		QuestManager.add_quest(q.id, q.name, q.desc)


# ------------------------------
# 다음 DAY로 이동
# ------------------------------
func go_next_day():
	var next_day = current_day + 1

	if !day_scenes.has(next_day):
		print("마지막 날짜입니다.")
		return

	load_day(next_day)
