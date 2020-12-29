extends Node

signal changed

var items = {
	
}

func add(name, quantity):
	assert(ItemManager.items.has(name))
	assert(quantity > 0)
	var current = items.get(name, 0)
	items[name] = current + quantity
	emit_signal("changed")

func remove(name, quantity):
	assert(ItemManager.items.has(name))
	assert(items.keys().has(name))
	assert(items[name] >= quantity)
	var current = items.get(name)
	if current == quantity:
		items.erase(name)
	else:
		items[name] = current - quantity
	emit_signal("changed")
