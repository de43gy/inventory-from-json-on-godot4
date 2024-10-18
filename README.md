# inventory-from-json-on-godot4
A prototype inventory system for Godot 4 that demonstrates loading and managing game items from external JSON files. This project shows how to implement a flexible and easily expandable inventory system that can be modified without changing the game code.

![image](https://github.com/user-attachments/assets/c84f9887-0e35-4ebe-8824-db59f75046b1)


## Technical Details

**Engine:** Godot 4
**Language:** GDScript
**Storage:** JSON
**UI:** Native Godot Control nodes

## Project Structure

```
├── data/
│   └── inventory_items.json    # Item database
├── scripts/
│   ├── Inventory.gd           # Core inventory logic
│   └── InventoryUI.gd         # UI handling
└── scenes/
    └── InventoryUI.tscn       # Main inventory scene
```

## Usage
gdscriptCopy# Example of adding items to inventory
var inventory = preload("res://scripts/Inventory.gd").new()
inventory.add_item("health_potion", 5)

## Customization
Add new items by editing the inventory_items.json file:
```json
jsonCopy{
    "new_item": {
        "id": "new_item",
        "name": "New Item",
        "description": "Description",
        "type": "type",
        "properties": {
            "custom_property": 100
        },
        "stack_size": 99
    }
}
```

## License
MIT License
