extends CanvasLayer

@onready var panel: PanelContainer = $Control/PanelContainer
@onready var item_list: ItemList = $Control/PanelContainer/VBoxContainer/ItemList
@onready var bag_button: TextureButton = $Control/BagButton

func _ready() -> void:
	# 가방 버튼은 클릭으로만 동작하게 (Space 방지)
	bag_button.focus_mode = Control.FOCUS_NONE
	bag_button.pressed.connect(_on_bag_button_pressed)

	print("[InventoryUI ready] ", get_path())
	panel.visible = false

	# ⭐ 인벤토리 변경 신호를 받아서 리스트 갱신
	Inventory.items_changed.connect(_refresh_list)

	# 처음 한 번도 현재 상태로 리스트 갱신
	_refresh_list()

func _on_bag_button_pressed() -> void:
	panel.visible = not panel.visible

func _refresh_list() -> void:
	item_list.clear()

	var items := Inventory.items
	print("[InventoryUI] _refresh_list, 아이템 개수:", items.size())

	if items.is_empty():
		var idx := item_list.add_item("None")
		item_list.set_item_disabled(idx, true)
		return

	for item in items:
		item_list.add_item(item.display_name, item.icon)
