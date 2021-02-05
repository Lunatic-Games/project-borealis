extends Node

const label_scene = preload("res://menus/text_label.tscn")

onready var item_list = $ManagerTest/ScrollContainer/ItemList
onready var single_label = $DisplayTests/SingleQuantity/TextLabel2
onready var multiple_label = $DisplayTests/MultipleQuantity/TextLabel2
onready var single_numbers_label = $DisplayTests/SingleQuantityNumbers/TextLabel2
onready var multiple_numbers_label = $DisplayTests/MultipleQuantityNumbers/TextLabel2

func _ready():
	for item_name in ItemManager.items:
		var label = label_scene.instance()
		label.text = ItemManager.items[item_name].display_name
		item_list.add_child(label)
	
	single_numbers_label.text = ItemManager.items["rock"].get_display_name(1, true)
	multiple_numbers_label.text = ItemManager.items["rock"].get_display_name(3, true)
	single_label.text = ItemManager.items["rock"].get_display_name(1)
	multiple_label.text = ItemManager.items["rock"].get_display_name(3)
	

