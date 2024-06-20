@tool
class_name CSGRepeater3D extends CSGCombiner3D

var template_node: Object

var _repeat: Vector3 = Vector3.ONE
@export var repeat: Vector3:
	get:
		return _repeat
	set(value):
		_repeat = value
		repeat_template()

var _spacing: Vector3 = Vector3.ONE
@export var spacing: Vector3:
	get:
		return _spacing
	set(value):
		_spacing = value
		repeat_template()

func _enter_tree():
	child_entered_tree.connect(on_child_enter)
	child_exiting_tree.connect(on_child_exit)

func on_child_enter(node):
	if template_node == null:
		template_node = node
		print(template_node.get_property_list())
		repeat_template()
		
func on_child_exit(node):
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
				add_child(new_node)
				
				# Set the new position based on spacing
				new_node.translate(Vector3(
					x * _spacing.x + template_node.position.x,
					y * _spacing.y + template_node.position.y,
					z * _spacing.z + template_node.position.z
				))
