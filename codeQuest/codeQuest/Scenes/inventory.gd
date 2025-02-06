import collectable.gd

class_name Inventory

extends Node

class Inv:
	var collectables = []
	func search (item_name:String) -> Collectable:
		#find item in inventory. If not present, create new item and return it.
		is_present = false
		for collectable in self.collectables:
			if collectable.name == item_name:
				is_present = true
				return collectable
		if is_present == false:
			new_collectable = collectable.new(item_name, 0)
			
				
	func add(item_name:String, add_quantity:int):
		pass
	func remove(item_name:String, rem_quantity:int):
		pass
	

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
