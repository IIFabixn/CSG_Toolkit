@tool
extends EditorPlugin
class_name CsgToolkit
var config: CsgTkConfig:
	get:
		return get_tree().root.get_node_or_null(AUTOLOAD_NAME) as CsgTkConfig
var dock
var operation: CSGShape3D.Operation = CSGShape3D.OPERATION_UNION
var selected_material: Material = Material.new()
const AUTOLOAD_NAME = "CsgToolkitAutoload"

func _enter_tree():
	# Config
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/csg_toolkit/scripts/csg_toolkit_config.gd")
	print(get_path())
	# Scene
	var dockScene = preload("res://addons/csg_toolkit/scenes/csg_toolkit_bar.tscn")
	dock = dockScene.instantiate()
	dock.pressed_csg.connect(create_csg)
	dock.operation_changed.connect(set_operation)
	dock.material_selected.connect(set_material)
	EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, dock)
	_on_selection_changed()

func set_operation(val: int):
	match val:
		0: operation = CSGShape3D.OPERATION_UNION
		1: operation = CSGShape3D.OPERATION_INTERSECTION
		2: operation = CSGShape3D.OPERATION_SUBTRACTION
		_: operation = CSGShape3D.OPERATION_UNION

func set_material(material: BaseMaterial3D):
	selected_material = material

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
	
	csg.operation = operation
	csg.material = selected_material

	if (selected_node.get_owner() == null):
		print("Selected Node has no owner")
		return

	if Input.is_key_pressed(config.action_key):
		if config.default_behavior == CsgTkConfig.CSGBehavior.SIBLING:
			_add_as_child(selected_node, csg)
		elif config.default_behavior == CsgTkConfig.CSGBehavior.CHILD:
			_add_as_sibling(selected_node, csg)
	else:
		if config.default_behavior == CsgTkConfig.CSGBehavior.SIBLING:
			_add_as_sibling(selected_node, csg)
		elif config.default_behavior == CsgTkConfig.CSGBehavior.CHILD:
			_add_as_child(selected_node, csg)

	EditorInterface.get_selection().clear()
	EditorInterface.get_selection().add_node(csg)

func _add_as_child(selected_node: CSGShape3D, csg: CSGShape3D):
	selected_node.add_child(csg, true)
	csg.owner = selected_node.get_owner()
	csg.global_position = selected_node.global_position
	
func _add_as_sibling(selected_node: CSGShape3D, csg: CSGShape3D):
	selected_node.get_parent().add_child(csg, true)
	csg.owner = selected_node.get_owner()
	csg.global_position = selected_node.global_position

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

func _exit_tree():
	dock.pressed_csg.disconnect(create_csg)
	dock.operation_changed.disconnect(set_operation)
	EditorInterface.get_selection().selection_changed.disconnect(_on_selection_changed)
	
	remove_autoload_singleton(AUTOLOAD_NAME)
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, dock)
	dock.free()
