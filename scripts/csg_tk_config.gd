@tool
extends Node
class_name CsgTkConfig
# Constants
const CSG_TOOLKIT = "CSG_TOOLKIT"
const DEFAULT_BEHAVIOR = "DEFAULT_BEHAVIOR" # sibling
const ACTION_KEY = "ACTION_KEY" # shift

# Configurable
var default_behavior: CSGBehavior = CSGBehavior.SIBLING
var action_key: Key = KEY_SHIFT

signal config_saved()

func _enter_tree():
	load_config()
	
func save_config():
	var config = ConfigFile.new()
	config.set_value(CSG_TOOLKIT, DEFAULT_BEHAVIOR, default_behavior)
	config.set_value(CSG_TOOLKIT, ACTION_KEY, action_key)
	config.save("res://addons/CSG_Toolkit/csg_tk_config.cfg")
	print("CsgToolkit: Saved Config")
	config_saved.emit()

func load_config():
	var config = ConfigFile.new()
	if config.load("res://addons/CSG_Toolkit/csg_tk_config.cfg") == OK:
		default_behavior = config.get_value(CSG_TOOLKIT, DEFAULT_BEHAVIOR, default_behavior)
		action_key = config.get_value(CSG_TOOLKIT, ACTION_KEY, action_key)
	else:
		save_config()
	print("CsgToolkit: Loaded Config")
	

enum CSGBehavior { SIBLING, CHILD }
