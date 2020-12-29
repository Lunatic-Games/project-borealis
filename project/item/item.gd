extends Resource

class_name Item

export (Texture) var image
export (String) var display_name
export (String) var plural_name

# Determine the string to display
func get_display_name(quantity, include_quantity=false):
	if quantity > 1:
		if include_quantity:
			return str(quantity) + " " + plural_name
		else:
			return plural_name
	else:
		if include_quantity:
			return str(quantity) + " " + display_name
		else:
			return display_name
