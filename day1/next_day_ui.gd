extends CanvasLayer

@onready var next_button = $NextDayButton
@onready var next_panel = $Panel


func _ready() -> void:
	layer = 100
	next_button.hide()
	next_panel.hide()


	# Panel과 Label이 마우스 클릭을 가로채지 않도록 설정
	next_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Panel/Label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# 버튼 클릭 허용
	next_button.disabled = false
	next_button.mouse_filter = Control.MOUSE_FILTER_STOP

	# 신호 연결
	DayManager.ready_for_next_day.connect(_on_day_ready)
	next_button.pressed.connect(_on_next_button_pressed)

	# 디버깅용
	next_button.mouse_entered.connect(
		func(): print("🖱️ 버튼 위에 마우스 진입")
	)

	print("✅ NextDayUI 준비 완료")


func _on_day_ready() -> void:
	print("✅ NextDay 버튼 활성화")

	next_button.show()
	next_panel.show()


func _on_next_button_pressed() -> void:
	print("🔥 NextDay 버튼 클릭 성공!")

	DayManager.next_day()

	next_button.hide()
	next_panel.hide()
