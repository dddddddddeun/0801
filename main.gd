extends Node2D # Node2D 상속

func _ready() -> void:  # -ready() : 노드가 씬 트리에 들어가 준비되면 실행됨
	get_node("/root/QuestUI").visible = false  # get_node("/root/QuestUI") : 
	# 씬 트리의 /root 아래에 있는 QuestUI 노드를 찾음
	# visible = fasle :해당 UI를 화면에서 숨김
	get_node("/root/DayUI").visible = false
	get_node("/root/InventoryUI").visible = false
