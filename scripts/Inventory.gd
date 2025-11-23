extends Node
class_name InventoryManager

signal items_changed

var items: Array[ItemData] = []

func add_item(item: ItemData) -> void:
	if item == null:
		return

	if not items.has(item):
		items.append(item)
		print("[Inventory] add_item:", item.display_name, "현재 개수:", items.size())
		items_changed.emit()

func remove_item(item: ItemData) -> void:
	var index := items.find(item)
	if index != -1:
		items.remove_at(index)
		items_changed.emit()

func clear() -> void:
	items.clear()
	items_changed.emit()
