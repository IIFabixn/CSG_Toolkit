@tool
class_name CSGMeshConverterButton extends Button

func _enter_tree():
	print("GEK")
	EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)
	_on_selection_changed()

func _exit_tree():
	EditorInterface.get_selection().selection_changed.disconnect(_on_selection_changed)

func _on_selection_changed():
	var selection = EditorInterface.get_selection().get_selected_nodes()
	if selection.is_empty():
		hide()
	elif selection[0] is CSGCombiner3D:
		show()
	else:
		hide()

func _on_pressed():
	pass # Replace with function body.
