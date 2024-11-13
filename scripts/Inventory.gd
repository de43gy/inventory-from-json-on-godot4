extends Node


var inventory = []
var inventory_data = {}

func _ready():
	load_inventory_data()

func load_inventory_data():
	if not FileAccess.file_exists("res://data/inventory_items.json"):
		push_error("Файл inventory_items.json не найден!")
		return
		
	var file = FileAccess.open("res://data/inventory_items.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			inventory_data = json.get_data()
		else:
			push_error("Ошибка парсинга JSON: " + str(parse_result))
		file.close()
	else:
		push_error("Не удалось открыть файл inventory_items.json")

func add_item(item_id: String, quantity: int = 1) -> bool:
	if not inventory_data.has(item_id):
		push_error("Предмет с ID " + item_id + " не найден в базе данных")
		return false
		
	var item = inventory_data[item_id].duplicate(true)
	
	for existing_item in inventory:
		if existing_item["id"] == item_id:
			if existing_item["quantity"] + quantity <= item["stack_size"]:
				existing_item["quantity"] += quantity
				return true
			return false
	
	item["quantity"] = min(quantity, item["stack_size"])
	inventory.append(item)
	return true

func remove_item(item_id: String, quantity: int = 1) -> bool:
	for i in range(inventory.size()):
		if inventory[i]["id"] == item_id:
			if inventory[i]["quantity"] <= quantity:
				inventory.remove_at(i)
			else:
				inventory[i]["quantity"] -= quantity
			return true
	return false

func get_item(item_id: String) -> Dictionary:
	for item in inventory:
		if item["id"] == item_id:
			return item
	return {}

func has_item(item_id: String, quantity: int = 1) -> bool:
	for item in inventory:
		if item["id"] == item_id and item["quantity"] >= quantity:
			return true
	return false

func get_item_quantity(item_id: String) -> int:
	for item in inventory:
		if item["id"] == item_id:
			return item["quantity"]
	return 0

func save_inventory():
	var file = FileAccess.open("res://data/saved_inventory.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(inventory))
		file.close()
		return true
	return false

func load_saved_inventory() -> bool:
	if not FileAccess.file_exists("res://data/saved_inventory.json"):
		return false
		
	var file = FileAccess.open("res://data/saved_inventory.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			inventory = json.get_data()
			file.close()
			return true
	return false

func clear_inventory():
	inventory.clear()

func get_all_items() -> Array:
	return inventory

func get_max_stack_size(item_id: String) -> int:
	if inventory_data.has(item_id):
		return inventory_data[item_id]["stack_size"]
	return 0
