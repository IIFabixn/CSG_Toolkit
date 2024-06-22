@tool
class_name CSGRepeater3D extends CSGCombiner3D

var template_node: CSGShape3D

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
	template_node = get_child(0)
	if template_node != null:
		repeat_template()

	child_entered_tree.connect(on_child_enter)
	child_exiting_tree.connect(on_child_exit)
	EditorInterface.get_inspector().property_edited.connect(Callable(self, "update_repeat"))
	

func _exit_tree():
	EditorInterface.get_inspector().property_edited.disconnect(Callable(self, "update_repeat"))

func on_child_enter(node: Node):
	if template_node == null:
		template_node = node
		repeat_template()

func update_repeat(prop: String):
	if EditorInterface.get_inspector().get_edited_object() == template_node:
		repeat_template()

func on_child_exit(node: Node):
	if node == template_node:
		template_node = null
		clear_children()
	
func clear_children():
	# Clear existing children except the template node
	for child in get_children():
		if child != template_node:
			call_deferred("remove_child", child)
			child.call_deferred("queue_free")

func repeat_template():
	if not template_node:
		print("No template node found.")
		return
	
	clear_children()
	
	# Clone and position the template node based on repeat and spacing
	for x in range(int(_repeat.x)):
		for y in range(int(_repeat.y)):
			for z in range(int(_repeat.z)):
				# Skip the first instance since it's the template node itself
				if x == 0 and y == 0 and z == 0:
					continue
				
				# Instance a new template node
				var new_node = template_node.duplicate()
				new_node.name = "%s_instance_%d_%d_%d" % [template_node.name, x, y, z]
				call_deferred("add_child", new_node)
				
				# Set the new position based on spacing
				new_node.translate(Vector3(
					x * (template_node.get_aabb().size.x + _spacing.x),
					y * (template_node.get_aabb().size.y + _spacing.y),
					z * (template_node.get_aabb().size.z + _spacing.z)
				))
