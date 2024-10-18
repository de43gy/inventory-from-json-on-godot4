# Inventory.gd
extends Node

# Основные переменные для хранения данных
var inventory = [] # Текущие предметы в инвентаре
var inventory_data = {} # Данные всех возможных предметов из JSON

func _ready():
	load_inventory_data()

# Загрузка данных о предметах из JSON файла
func load_inventory_data():
	# Проверяем существование файла
	if not FileAccess.file_exists("res://data/inventory_items.json"):
		push_error("Файл inventory_items.json не найден!")
		return
		
	# Открываем файл
	var file = FileAccess.open("res://data/inventory_items.json", FileAccess.READ)
	if file:
		# Читаем содержимое файла
		var json_string = file.get_as_text()
		var json = JSON.new()
		# Разбираем JSON
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			inventory_data = json.get_data()
		else:
			push_error("Ошибка парсинга JSON: " + str(parse_result))
		file.close()
	else:
		push_error("Не удалось открыть файл inventory_items.json")

# Добавление предмета в инвентарь
func add_item(item_id: String, quantity: int = 1) -> bool:
	if not inventory_data.has(item_id):
		push_error("Предмет с ID " + item_id + " не найден в базе данных")
		return false
		
	# Создаем копию данных предмета
	var item = inventory_data[item_id].duplicate(true)
	
	# Проверяем, есть ли уже такой предмет в инвентаре
	for existing_item in inventory:
		if existing_item["id"] == item_id:
			# Если предмет стакается и не превышает максимальный размер стака
			if existing_item["quantity"] + quantity <= item["stack_size"]:
				existing_item["quantity"] += quantity
				return true
			return false
	
	# Если предмет новый, добавляем его
	item["quantity"] = min(quantity, item["stack_size"])
	inventory.append(item)
	return true

# Удаление предмета из инвентаря
func remove_item(item_id: String, quantity: int = 1) -> bool:
	for i in range(inventory.size()):
		if inventory[i]["id"] == item_id:
			if inventory[i]["quantity"] <= quantity:
				inventory.remove_at(i)
			else:
				inventory[i]["quantity"] -= quantity
			return true
	return false

# Получение информации о предмете
func get_item(item_id: String) -> Dictionary:
	for item in inventory:
		if item["id"] == item_id:
			return item
	return {}

# Проверка наличия предмета
func has_item(item_id: String, quantity: int = 1) -> bool:
	for item in inventory:
		if item["id"] == item_id and item["quantity"] >= quantity:
			return true
	return false

# Получение количества предмета
func get_item_quantity(item_id: String) -> int:
	for item in inventory:
		if item["id"] == item_id:
			return item["quantity"]
	return 0

# Сохранение текущего состояния инвентаря
func save_inventory():
	var file = FileAccess.open("res://data/saved_inventory.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(inventory))
		file.close()
		return true
	return false

# Загрузка сохраненного состояния инвентаря
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

# Очистка инвентаря
func clear_inventory():
	inventory.clear()

# Получение всего списка предметов
func get_all_items() -> Array:
	return inventory

# Получение максимального размера стака для предмета
func get_max_stack_size(item_id: String) -> int:
	if inventory_data.has(item_id):
		return inventory_data[item_id]["stack_size"]
	return 0
	
	ProjectSettings
