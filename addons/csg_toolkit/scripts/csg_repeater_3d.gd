@tool
class_name CSGRepeater3D extends CSGCombiner3D

var _template_node: CSGShape3D
@export var template_node: CSGShape3D:
	get: return _template_node
	set(value):
		_template_node = value
		notify_property_list_changed()
		if value:
			repeat_template()
		else: 
			clear_children()

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
	if not child_entered_tree.is_connected(_on_child_entered):
		child_entered_tree.connect(_on_child_entered)
	if not child_exiting_tree.is_connected(_on_child_existing):
		child_exiting_tree.connect(_on_child_existing)
	if not EditorInterface.get_inspector().property_edited.is_connected(update_repeat):
		EditorInterface.get_inspector().property_edited.connect(update_repeat)

var changed_type = false # fixes breaking repeater after type change
func _on_child_entered(node):
	changed_type = false
	if not template_node:
		template_node = node
	elif node.get_class() != template_node.get_class():
			changed_type = true
			template_node = node

func _on_child_existing(node: Node3D):
	if node == template_node:
		call_deferred("_clear_template", node)

func _clear_template(node):
	if template_node.get_parent() == self:
		# fixes reparent problem
		if not changed_type:
			template_node = null
	else:
		template_node = template_node.get_parent()

func _exit_tree():
	EditorInterface.get_inspector().property_edited.disconnect(update_repeat)

func update_repeat(prop: String):
	if EditorInterface.get_inspector().get_edited_object() == template_node:
		repeat_template()
	
func clear_children():
	# Clear existing children except the template node
	for child in get_children(true):
		if child == template_node: continue
		call_deferred("remove_child", child)
		child.call_deferred("queue_free")

func repeat_template():
	if not template_node:
		print("No Template found")
		return
	clear_children()
	# Clone and position the template node based on repeat and spacing
	for x in range(int(_repeat.x)):
		for y in range(int(_repeat.y)):
			for z in range(int(_repeat.z)):
				if x == 0 and y == 0 and z == 0: continue
				# Instance a new template node
				var new_node = template_node.duplicate()
				new_node.name = "%s_instance_%d_%d_%d" % [template_node.name, x, y, z]
				call_deferred("add_node", x, y, z, new_node)

func add_node(x: int, y: int, z: int, node: CSGShape3D):
	add_child(node, false, Node.INTERNAL_MODE_BACK)
	# Set the new position based on spacing
	node.translate(Vector3(
		x * (template_node.get_aabb().size.x + _spacing.x),
		y * (template_node.get_aabb().size.y + _spacing.y),
		z * (template_node.get_aabb().size.z + _spacing.z)
	))
