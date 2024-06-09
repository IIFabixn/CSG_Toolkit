@tool
extends EditorPlugin

var dock

func _enter_tree():
	var dockScene = preload("res://addons/csg_shortcut/csg_item_bar.tscn")
	dock = dockScene.instantiate()
	dock.pressed_csg.connect(create_csg)
	EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, dock)
	_on_selection_changed()
	print("Enabled CSG Item Bar")

func create_csg(type: Variant):
	var selected_nodes = get_editor_interface().get_selection().get_selected_nodes()
	if selected_nodes.is_empty() or !(selected_nodes[0] is CSGShape3D):
		# Do not create a csg if not inside another csgshape
		return
	var selected_node: CSGShape3D = selected_nodes[0]
	var csg: CSGShape3D
	match type:
		CSGBox3D:
			csg = CSGBox3D.new()
		CSGCylinder3D:
			csg = CSGCylinder3D.new()
		CSGSphere3D:
			csg = CSGSphere3D.new()
		CSGMesh3D:
			csg = CSGMesh3D.new()
		CSGPolygon3D:
			csg = CSGPolygon3D.new()
		CSGTorus3D:
			csg = CSGTorus3D.new()
	selected_node.add_child(csg, true)
	csg.owner = selected_node.owner
	EditorInterface.get_selection().clear()
	EditorInterface.get_selection().add_node(csg)

func _exit_tree():
	dock.pressed_csg.disconnect(create_csg)
	EditorInterface.get_selection().selection_changed.disconnect(_on_selection_changed)
	
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, dock)
	dock.free()
	print("Disabled CSG Item Bar")

func _on_selection_changed():
	# Get the current selected nodes
	var selected_nodes = get_editor_interface().get_selection().get_selected_nodes()
	# Check if the selected node is a CSGShape
	if !selected_nodes.is_empty() and selected_nodes[0] is CSGShape3D:
		# Make the plugin visible
		dock.show()
	else:
		# Hide the plugin UI if the selected node is not a CSG node
		dock.hide()
