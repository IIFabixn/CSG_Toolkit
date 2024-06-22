class_name CSGUpdateRepeaterButton extends Button

signal request_refresh()

func _enter_tree():
	EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)

func _exit_tree():
	EditorInterface.get_selection().selection_changed.disconnect(_on_selection_changed)

func _on_selection_changed():
	print("rb changed")
	var selection = EditorInterface.get_selection().get_selected_nodes()
	if selection.is_empty():
		print("e")
		hide()
	elif selection[0] is CSGRepeater3D:
		print("c")
		show()
	elif (selection[0] as Node).find_parent("CSGRepeater3D"):
		print("y")
		show()
	else:
		print("n")
		hide()

func _on_pressed():
	request_refresh.emit()
