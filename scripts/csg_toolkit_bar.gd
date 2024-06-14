@tool
extends Control

signal pressed_csg(type: Variant)
signal operation_changed(operation: int)

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
