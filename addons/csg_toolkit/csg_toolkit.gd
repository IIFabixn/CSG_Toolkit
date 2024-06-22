@tool
class_name CsgToolkit extends EditorPlugin
@onready var config: CsgTkConfig:
	get:
		return get_tree().root.get_node_or_null(AUTOLOAD_NAME) as CsgTkConfig
var dock: CSGToolkitBar
var repeater_refresh_button: CSGUpdateRepeaterButton
const AUTOLOAD_NAME = "CsgToolkitAutoload"
static var csg_plugin_path
func _enter_tree():
	# Config
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/csg_toolkit/scripts/csg_toolkit_config.gd")
	csg_plugin_path = get_path()
	# Nodes
	add_custom_type("CSGRepeater3D", "CSGCombiner3D", preload("res://addons/csg_toolkit/scripts/csg_repeater_3d.gd"), null)
	# Toolkit bar
	var dockScene = preload("res://addons/csg_toolkit/scenes/csg_toolkit_bar.tscn")
	dock = dockScene.instantiate()
	# Repeater Button
	var repeater_update_button_scene = preload("res://addons/csg_toolkit/scenes/csg_refresh_repeater_button.tscn")
	repeater_refresh_button = repeater_update_button_scene.instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, dock)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, repeater_refresh_button)

func _exit_tree():
	remove_custom_type("CSGRepeater3D")
	
	remove_autoload_singleton(AUTOLOAD_NAME)
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_LEFT, dock)
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, repeater_refresh_button)
	dock.free()
