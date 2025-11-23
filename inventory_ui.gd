extends CanvasLayer

@onready var panel: PanelContainer = $Control/PanelContainer
@onready var item_list: ItemList = $Control/PanelContainer/VBoxContainer/ItemList
@onready var bag_button: TextureButton = $Control/BagButton

@onready var detail_panel: PanelContainer = $Control/DetailPanel
@onready var detail_image: TextureRect = $Control/DetailPanel/Control/ItemImage
@onready var detail_label: Label = $Control/DetailPanel/Control/ItemLabel
@onready var close_button: TextureButton = $Control/DetailPanel/Control/Close

func _ready() -> void:
	print("[InventoryUI ready] ", get_path())

	bag_button.focus_mode = Control.FOCUS_NONE
	bag_button.pressed.connect(_on_bag_button_pressed)

	panel.visible = false
	detail_panel.visible = false

	# 인벤토리 변경되면 리스트 갱신
	Inventory.items_changed.connect(_refresh_list)
	_refresh_list()

	# 🔥 여기 중요: ItemList 클릭 시 함수 연결
	if not item_list.is_connected("item_selected", Callable(self, "_on_item_selected")):
		item_list.item_selected.connect(_on_item_selected)

	close_button.pressed.connect(_on_close_button_pressed)

func _on_bag_button_pressed() -> void:
	panel.visible = not panel.visible
	if not panel.visible:
		detail_panel.visible = false

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

func _on_item_selected(index: int) -> void:
	print("[InventoryUI] _on_item_selected index:", index)

	var items := Inventory.items
	if index < 0 or index >= items.size():
		return

	var item: ItemData = items[index]
	_show_item_detail(item)

func _show_item_detail(item: ItemData) -> void:
	if item.detail_image:
		detail_image.texture = item.detail_image
	else:
		detail_image.texture = item.icon

	detail_label.text = "%s\n\n%s" % [item.display_name, item.description]

	detail_panel.visible = true
	print("[InventoryUI] detail_panel.visible =", detail_panel.visible)

func _on_close_button_pressed() -> void:
	detail_panel.visible = false
