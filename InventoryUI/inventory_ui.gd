extends Control

@onready var item_list = $PanelContainer/HBoxContainer/ItemList
@onready var property_list = $PanelContainer/HBoxContainer/Properties/PropertyList
@onready var description_label = $PanelContainer/HBoxContainer/Properties/Description

var inventory: Node

func _ready():
	inventory = preload("res://scripts/Inventory.gd").new()
	inventory.load_inventory_data()
	refresh_item_list()
	
	item_list.item_selected.connect(_on_item_selected)

func refresh_item_list():
	item_list.clear()
	
	for item_id in inventory.inventory_data.keys():
		var item = inventory.inventory_data[item_id]
		item_list.add_item(item["name"])
		
		var idx = item_list.get_item_count() - 1
		item_list.set_item_metadata(idx, item)

func _on_item_selected(index: int):
	var item = item_list.get_item_metadata(index)
	update_property_list(item)
	
func update_property_list(item: Dictionary):
	property_list.clear()
	
	property_list.add_item("ID: " + item["id"])
	property_list.add_item("Тип: " + item["type"])
	property_list.add_item("Макс. в стаке: " + str(item["stack_size"]))
	
	for prop_name in item["properties"]:
		var value = item["properties"][prop_name]
		property_list.add_item(prop_name + ": " + str(value))
	
	description_label.text = item["description"]
