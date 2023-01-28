extends SubViewportContainer
@onready var image = $"%Image"


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			image.scale -= Vector2(0.1,0.1)
			image.update_pivot()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			image.scale += Vector2(0.1,0.1)
			image.update_pivot()

