extends ItemList
@onready var image: TextureRect = $"%Image"
@onready var slider_list: VBoxContainer = $"%SliderList"
@onready var viewport: SubViewport = $"%MainImageViewport"

@onready var save_dialog: FileDialog = $"%SaveWindow"

var shader_names: Array
var shaders: Dictionary
var uniforms: Dictionary
var param_file: shader_params = null


func _ready():
	generate_list()
	update_list()
	image.material = null


func generate_list():
	var files := DirAccess.get_files_at("res://shaders/")
	for i in files:
		var _name =  i
		name = _name.replace(".gdshader", "")
		shader_names.append(name)
		shaders[name] = load("res://shaders/" + name + ".gdshader")


func update_list():
	clear()
	for i in shader_names:
		add_item(i)


func activate_shader(activated_shader_name: String):
	param_file = null
	var new_material: ShaderMaterial = ShaderMaterial.new()
	new_material.shader = shaders[activated_shader_name]
	
	for i in slider_list.get_children():
		i.name = "Junk" + str(i.get_index())
		i.queue_free()
	
	image.material = new_material
	
	if activated_shader_name == "kuwahara5":
		image.material.set_shader_parameter("iChannel1", image.texture)
		
	if  ResourceLoader.exists("res://shader_params/" + str(activated_shader_name) + ".tres"):
		activate_params(activated_shader_name)
		update_params()

	image.update_pivot()


func activate_params(activated_shader_name: String):
	param_file = load( "res://shader_params/" + activated_shader_name + ".tres" )
	
	for i in param_file.default_params:
		param_file.current_params[i] = param_file.default_params[i]
		image.material.set_shader_parameter(str(param_file.default_params[i]), i)

	for a in param_file.params.keys():
		var label = Label.new()
#		label.custom_minimum_size = Vector2(25, 45)
		slider_list.add_child(label)
		label.name = a + "Label"
		
		var slider = HSlider.new()
		slider_list.add_child(slider)
		slider.name = a + "Slider"
		
		if param_file.rounded_params.has(a):
			slider.rounded = true
		
		slider.min_value = param_file.params[a].x
		slider.max_value = param_file.params[a].y
		slider.step = 0.01	
		slider.value = param_file.current_params[a]
		slider.connect("value_changed", Callable(self,"on_slider_change").bind(slider))


func update_params():
	
	for a in param_file.params.keys():
		var label = slider_list.get_node("./" + a + "Label")
		var slider = slider_list.get_node("./" + a + "Slider")
		label.text = a + ": " + str(slider.value)


func _on_shaderlist_item_selected(index):
	activate_shader(get_item_text(index))


func on_slider_change(value, slider):
	var shader_name = slider.name.replace("Slider", "")
	
	update_params()
	image.material.set_shader_parameter(shader_name, value)


func _on_button_down():

	save_dialog.popup_centered(Vector2i(500,500))
	save_dialog.current_file = "result.png"


func _on_file_dialog_file_selected(path):
	image.texture = load_ext_image(path)
	image.update_pivot()


func load_ext_image(path: String):

	var img = Image.load_from_file(path)
	var imgtex = ImageTexture.create_from_image(img)
	
	return imgtex


func _on_save_file_selected(path):
	prints("saved at ", path)
	var export_img = viewport.get_texture().get_image()
	export_img.save_png(path)

