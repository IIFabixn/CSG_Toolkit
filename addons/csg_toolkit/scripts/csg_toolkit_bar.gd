@tool
extends Control

signal pressed_csg(type: Variant)
signal operation_changed(operation: int)
signal material_selected(mat: BaseMaterial3D)
signal shader_selected(mat: ShaderMaterial)

@onready var picker_button: Button = $MarginContainer/ScrollContainer/HBoxContainer/Material/MaterialPicker

func _ready():
	picker_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _on_box_pressed():
	self.pressed_csg.emit(CSGBox3D)

func _on_cylinder_pressed():
	self.pressed_csg.emit(CSGCylinder3D)

func _on_mesh_pressed():
	self.pressed_csg.emit(CSGMesh3D)

func _on_polygon_pressed():
	self.pressed_csg.emit(CSGPolygon3D)

func _on_sphere_pressed():
	self.pressed_csg.emit(CSGSphere3D)

func _on_torus_pressed():
	self.pressed_csg.emit(CSGTorus3D)

# Operation Toggle
func _on_operation_pressed(val):
	self.operation_changed.emit(val)

func _on_config_pressed():
	var config_view_scene = preload("res://addons/csg_toolkit/scenes/config_window.tscn")
	var config_view = config_view_scene.instantiate()
	config_view.close_requested.connect(func ():
		get_tree().root.remove_child(config_view)
		config_view.queue_free()
	)
	get_tree().root.add_child(config_view)


func _request_material():
	var dialog = EditorFileDialog.new()
	dialog.title = "Select Material"
	dialog.display_mode = EditorFileDialog.DISPLAY_LIST
	dialog.filters = ["*.tres, *.material, *.res"]
	dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	dialog.position = ((EditorInterface.get_base_control().size / 2) as Vector2i) - dialog.size
	dialog.close_requested.connect(func ():
		get_tree().root.remove_child(dialog)
		dialog.queue_free()
	)
	get_tree().root.add_child(dialog)
	dialog.show()
	var res_path = await dialog.file_selected
	var res = ResourceLoader.load(res_path)
	if res == null: 
		return
	if res is BaseMaterial3D:
		self.material_selected.emit(res)
	elif res is ShaderMaterial:
		self.shader_selected.emit(res)
	else:
		return
	var previewer = EditorInterface.get_resource_previewer()
	previewer.queue_edited_resource_preview(res, self, "_update_picker_icon", null) 
	
func _update_picker_icon(path, preview, thumbnail, userdata):
	picker_button.icon = preview
