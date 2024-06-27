@tool
class_name CSGRepeater3D extends CSGCombiner3D

const REPEATER_NODE_META = "REPEATED_NODE_META"

var _template_node: CSGShape3D = null
@export var template_node: CSGShape3D = null:
	get: return _template_node
	set(value):
		_template_node = value
		notify_property_list_changed()
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

func _enter_tree():
	if not Engine.is_editor_hint(): return
	if not child_entered_tree.is_connected(_on_child_entered):
		child_entered_tree.connect(_on_child_entered)
	if not child_exiting_tree.is_connected(_on_child_existing):
		child_exiting_tree.connect(_on_child_existing)
	if not EditorInterface.get_inspector().property_edited.is_connected(update_repeat):
		EditorInterface.get_inspector().property_edited.connect(update_repeat)

func _on_child_entered(node: CSGShape3D):
	if not template_node:
		template_node = node

func _on_child_existing(node: Node3D):
	if node == template_node:
		template_node = null

func _exit_tree():
	if not Engine.is_editor_hint(): return
	child_entered_tree.disconnect(_on_child_entered)
	child_exiting_tree.disconnect(_on_child_existing)
	EditorInterface.get_inspector().property_edited.disconnect(update_repeat)

func update_repeat(prop: String):
	if EditorInterface.get_inspector().get_edited_object() == template_node:
		repeat_template()
	
func clear_children():
	# Clear existing children except the template node
	for child in get_children(true):
		if child == template_node || not child.has_meta(REPEATER_NODE_META): continue
		child.queue_free() # free repeated ndoes

func repeat_template(refresh_template = false):
	clear_children()
	if not template_node:
		if refresh_template and get_child_count() > 0:
			template_node = get_child(get_child_count() - 1)
		else: print("No Template found")
		return
	# Clone and position the template node based on repeat and spacing
	for x in range(int(_repeat.x)):
		for y in range(int(_repeat.y)):
			for z in range(int(_repeat.z)):
				if x == 0 and y == 0 and z == 0: continue
				# Instance a new template node
				var new_node = template_node.duplicate()
				new_node.name = "%s_csg_repeat_%d_%d_%d" % [template_node.name, x, y, z]
				new_node.set_meta(REPEATER_NODE_META, true)
				call_deferred("add_node", x, y, z, new_node)

func add_node(x: int, y: int, z: int, node: CSGShape3D):
	add_child(node, false, Node.INTERNAL_MODE_BACK)
	# Set the new position based on spacing
	node.translate(Vector3(
		x * (template_node.get_aabb().size.x + _spacing.x),
		y * (template_node.get_aabb().size.y + _spacing.y),
		z * (template_node.get_aabb().size.z + _spacing.z)
	))
