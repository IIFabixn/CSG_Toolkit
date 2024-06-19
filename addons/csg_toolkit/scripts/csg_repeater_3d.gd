@tool
class_name CSGRepeater3D extends CSGCombiner3D

var template_node: Node3D

@export_group("Repeat")
var _repeat_x: int = 0
@export var repeat_x: int:
	get:
		return _repeat_x
	set(value):
		_repeat_x = value
		repeat()

var _repeat_y: int = 0
@export var repeat_y: int:
	get:
		return _repeat_y
	set(value):
		_repeat_y = value
		repeat()

var _repeat_z: int = 0
@export var repeat_z: int:
	get:
		return _repeat_z
	set(value):
		_repeat_z = value
		repeat()

func _enter_tree():
	# Connect the child_entered_tree signal to update_template_node method
	child_entered_tree.connect(update_template_node)

func update_template_node(node: Node):
	if node is Node3D and get_child_count() == 1:
		template_node = node

func repeat():
	print("Repeat")
	if not template_node:
		print("No template node found.")
		return
	
	# Clear existing children except the template node
	for child in get_children():
		if child != template_node:
			child.queue_free()
	
	# Create new repeated instances
	for x in range(repeat_x + 1):
		for y in range(repeat_y + 1):
			for z in range(repeat_z + 1):
				if x == 0 and y == 0 and z == 0:
					continue # Skip the original template node position
				var new_instance = template_node.duplicate()
				new_instance.translate(Vector3(x, y, z))
				add_child(new_instance)
