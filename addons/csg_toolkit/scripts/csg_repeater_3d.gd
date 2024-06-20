@tool
class_name CSGRepeater3D extends CSGCombiner3D

var template_node: Node3D

var _repeat: Vector3 = Vector3.ZERO
@export var repeat: Vector3:
	get:
		return _repeat
	set(value):
		_repeat = value
		repeat_template()

var _spacing: Vector3 = Vector3.ZERO
@export var spacing: Vector3:
	get:
		return _spacing
	set(value):
		_spacing = value
		repeat_template()

func _enter_tree():
	if get_child_count() == 1:
		template_node = get_child(0)
	# Connect the child_entered_tree signal to update_template_node method
	child_entered_tree.connect(update_template_node)
	repeat_template()

func update_template_node(node: Node):
	if node is Node3D and get_child_count() == 1:
		template_node = node

func repeat_template():
	print("Repeat")
	if not template_node:
		print("No template node found.")
		return
	
	# Clear existing children except the template node
	for child in get_children():
		if child != template_node:
			child.queue_free()
	
	# Create new repeated instances
	for x in range(repeat.x + 1):
		for y in range(repeat.y + 1):
			for z in range(repeat.z + 1):
				if x == 0 and y == 0 and z == 0:
					continue # Skip the original template node position
				var new_instance = template_node.duplicate()
				new_instance.translate(Vector3(x , y, z))
				add_child(new_instance)
