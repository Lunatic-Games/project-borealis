extends Resource

class_name Item

export (Texture) var image
export (String) var display_name
export (String) var plural_name

# Create a readable string, optionally with the quantity included
func get_display_name(quantity: int, include_quantity: bool = false):
	assert(quantity >= 0)
	
	var s = plural_name if quantity > 1 else display_name
	if include_quantity:
		s = str(quantity) + " " + s
	return s
