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
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			image.scale = Vector2(1, 1)
			image.update_pivot()
		image.scale.x = clamp(image.scale.x, 0.35, 1.5)
		image.scale.y = clamp(image.scale.y, 0.35, 1.5)
		print(image.scale)
