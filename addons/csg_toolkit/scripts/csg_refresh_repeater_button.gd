@tool
class_name CSGUpdateRepeaterButton extends Button

func _enter_tree():
	EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)

func _exit_tree():
	EditorInterface.get_selection().selection_changed.disconnect(_on_selection_changed)

func _on_selection_changed():
	var selection = EditorInterface.get_selection().get_selected_nodes()
	if selection.is_empty():
		hide()
	elif selection[0] is CSGRepeater3D:
		show()
	elif (selection[0] as Node).find_parent("CSGRepeater3D"):
		show()
	else:
		hide()

func _on_pressed():
	var selection = EditorInterface.get_selection().get_selected_nodes()
	var repeater = selection[0] as CSGRepeater3D
	if not repeater:
		repeater = (selection[0] as Node).find_parent("CSGRepeater3D")
	if repeater and repeater.has_method("repeat_template"):
		repeater.call("repeat_template", true)
