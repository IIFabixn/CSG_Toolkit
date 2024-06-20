@tool
extends Window

var config: CsgTkConfig
@onready var action_key_button: Button = $MarginContainer/VBoxContainer/HBoxContainer2/Button
@onready var default_behavior_option: OptionButton = $MarginContainer/VBoxContainer/HBoxContainer/OptionButton
@onready var auto_hide_switch: CheckBox = $MarginContainer/VBoxContainer/HBoxContainer3/CheckButton
signal key_press(key: InputEventKey)
func _enter_tree():
	config = get_tree().root.get_node(CsgToolkit.AUTOLOAD_NAME) as CsgTkConfig
func _ready():
	default_behavior_option.select(config.default_behavior)
	action_key_button.text = OS.get_keycode_string(config.action_key)
	auto_hide_switch.set_pressed_no_signal(config.auto_hide)

func _on_option_button_item_selected(index):
	match index:
		0: config.default_behavior = CsgTkConfig.CSGBehavior.SIBLING
		1: config.default_behavior = CsgTkConfig.CSGBehavior.CHILD

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			key_press.emit(event)

func _on_save_pressed():
	config.save_config()


func _on_button_pressed():
	var key_event: InputEventKey = await key_press
	config.action_key = key_event.keycode
	action_key_button.text = key_event.as_text_key_label()


func _on_check_box_toggled(toggled_on):
	config.auto_hide = toggled_on
