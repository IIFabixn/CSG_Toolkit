@tool
extends Control

signal pressed_csg(type: Variant)
func _enter_tree():
	print("ENTERED")

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
