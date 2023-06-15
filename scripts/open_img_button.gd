extends Button


@onready var file_system = $"%LoadWindow"

# Called when the node enters the scene tree for the first time.
func _ready():
	file_system.add_filter("*.jpeg, *.jpg, *.png", "Images")
	file_system.access = file_system.ACCESS_FILESYSTEM





func _on_pressed():
	file_system.popup_centered(Vector2i(500, 500))
	file_system.invalidate()
	file_system.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)

