extends Node

const label_scene = preload("res://menus/text_label.tscn")

onready var item_list = $MarginContainer/ScrollContainer/ItemList

func _ready():
	for item_name in ItemManager.items:
		var label = label_scene.instance()
		label.text = ItemManager.items[item_name].display_name
		item_list.add_child(label)
