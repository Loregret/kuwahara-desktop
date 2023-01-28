extends Button


@onready var file_system = $"%LoadWindow"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_pressed():
#	file_system.visible = true
	file_system.popup_centered(Vector2i(500, 500))
	file_system.add_filter("*.jpeg, *.jpg, *.png", "Images")

