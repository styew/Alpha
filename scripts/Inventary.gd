extends Node
class_name Inventory


const INVENTORY_SIZE := 12
const HOTBAR_SIZE := 4


var slots: Array[ItemData] = []


func _ready() -> void:

	slots.resize(INVENTORY_SIZE)

	print("Inventário criado.")
	print("Slots: ", INVENTORY_SIZE)


func add_item(item: ItemData) -> bool:

	for i in range(INVENTORY_SIZE):

		if slots[i] == null:

			slots[i] = item

			print(
				"Item adicionado: ",
				item.item_name,
				" no slot ",
				i
			)

			return true


	print("Inventário cheio.")

	return false
