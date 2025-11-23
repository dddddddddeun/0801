extends CanvasLayer

@onready var next_button = $NextDayButton
@onready var next_panel = $Panel

func _ready():
	# 버튼은 처음에 비활성화
	next_button.visible = false
	next_panel.visible = false
	# DayManager 신호 연결
	DayManager.ready_for_next_day.connect(_on_day_ready)

	# 버튼 클릭
	next_button.pressed.connect(_on_next_button_pressed)


# ==========================================================
#  DayManager가 “다음 Day로 이동 가능" 신호를 보냈을 때
# ==========================================================
func _on_day_ready():
	print("[NextDayUI] Next day button 활성화됨")
	next_button.visible = true
	next_panel.visible = true


# ==========================================================
#  버튼 눌렀을 때 다음 Day로 이동
# ==========================================================
func _on_next_button_pressed():
	DayManager.next_day()
	next_button.visible = false  # 다음 day에서는 다시 숨기기
	next_panel.visible = false
