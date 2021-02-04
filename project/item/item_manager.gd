extends Node

# Dictionary of all item resources
# item_name : item_resource
var items = {
	
}

# Read all item resources from res://item/items/
func _ready():
	var directories = ["res://item/items"]  # Stack for depth-first search
	var current_dir = Directory.new()
	
	while directories:
		assert(current_dir.open(directories.pop_front()) == OK)
		
		# Iterate all files and directories in the current directory
		current_dir.list_dir_begin(true, true)
		var f_name = current_dir.get_next()
		while f_name != "":
			var f_path = "%s/%s" % [current_dir.get_current_dir(), f_name]
			if current_dir.current_is_dir():  # Add directories to stack
				directories.append(f_path)
			elif f_name.ends_with(".tres"):  # Load resources
				var res_name = f_name.trim_suffix(".tres")
				assert(!items.has(res_name))  # Don't want duplicate keys
				items[res_name] = load(f_path)
			f_name = current_dir.get_next()
		current_dir.list_dir_end()
