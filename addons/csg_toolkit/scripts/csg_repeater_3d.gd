@tool
class_name CSGRepeater3D extends CSGCombiner3D

const REPEATER_NODE_META = "REPEATED_NODE_META"

var _template_node_path: NodePath
@export var template_node_path: NodePath:
	get: return _template_node_path
	set(value):
		_template_node_path = value
		repeat_template()

var _repeat: Vector3 = Vector3.ONE
@export var repeat := Vector3.ONE:
	get:
		return _repeat
	set(value):
		_repeat = value
		repeat_template()

var _spacing: Vector3 = Vector3.ZERO
@export var spacing := Vector3.ZERO:
	get:
		return _spacing
	set(value):
		_spacing = value
		repeat_template()

func _ready() -> void:
	repeat_template()

func _exit_tree():
	if not Engine.is_editor_hint(): return
	
func clear_children():
	# Clear existing children except the template node
	for child in get_children(true):
		if child.has_meta(REPEATER_NODE_META):
			child.queue_free() # free repeated ndoes

func repeat_template():
	clear_children()

	var template_node = get_node_or_null(template_node_path)
	if not template_node:
		return
	
	# Clone and position the template node based on repeat and spacing
	for x in range(int(_repeat.x)):
		for y in range(int(_repeat.y)):
			for z in range(int(_repeat.z)):
				if x == 0 and y == 0 and z == 0: continue
				# Instance a new template node
				var instance = template_node.duplicate()
				instance.set_meta(REPEATER_NODE_META, true)
				# Position the instance
				var position = Vector3(
					x * (_spacing.x + template_node.transform.origin.x),
					y * (_spacing.y + template_node.transform.origin.y),
					z * (_spacing.z + template_node.transform.origin.z)
				)
				instance.transform.origin = position
				# Add the instance to the combiner
				add_child(instance)
