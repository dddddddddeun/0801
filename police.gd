extends CharacterBody2D

@export var npc_name = "경찰"

# 회차별 대화 세트
var dialogues = [
	[
		{"npc": "안녕. 처음 보는 얼굴이네."},
		{"player": "네, 방금 왔어요."},
		{"npc": "이 마을은 조심해야 해."}
	],
	[
		{"npc": "또 왔구나."},
		{"npc": "혹시 도움이 필요해?"}
	]
]

var talk_count = 0
var player_in_range = false

func _ready():
	$Area2D.body_entered.connect(_on_enter)
	$Area2D.body_exited.connect(_on_exit)
	DialogueManager.dialogue_finished.connect(_on_dialogue_end)

func _on_enter(body):
	if body.name == "Player":
		player_in_range = true

func _on_exit(body):
	if body.name == "Player":
		player_in_range = false

func _input(event):
	if player_in_range and !DialogueManager.talking:
		if event.is_action_pressed("talk"): # R
			_start_dialogue()

	# Space 로 대사 넘기기
	if DialogueManager.talking and event.is_action_pressed("ui_accept"):
		DialogueManager.next()

func _start_dialogue():
	var set_id = min(talk_count, dialogues.size() - 1)
	DialogueManager.start_dialogue(npc_name, dialogues[set_id])
	talk_count += 1

func _on_dialogue_end():
	# 예: 첫 대화 끝나면 퀘스트 시작
	if talk_count == 1:
		QuestManager.start_quest("find_ring")
