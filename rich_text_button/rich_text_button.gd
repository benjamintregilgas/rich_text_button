@tool
@icon("uid://bth6r3jl16eqm")
class_name RichTextButton
extends BaseButton
## A standard themed [Button] that displays RichText from a [RichTextLabel].
##
## [RichTextButton] is initially a standard themed [Button]. It can contain text,
## and will display them according to the current [member theme_resource].
## [br][br]
## [b]Example:[/b] Create a RichTextButton with bold text and connect a method
## that will be called when the button is pressed:
## [codeblock lang=gdscript]
## func _ready() -> void:
##     var rtb = RichTextButton.new()
##     rtb.text = "Click the [b]Bold[/b] text!"
##     rtb.pressed.connect(_rtb_pressed)
##     add_child(rtb)
## 
## func _rtb_pressed() -> void:
##     print("You clicked the bold text!")
## [/codeblock]
## [b]Note:[/b] RichTextButtons do not detect touch input, similar to [Button],
## and therefore don't support multitouch, since mouse emulation can only press one button
## at a given time. Use [TouchScreenButton] for buttons that trigger gameplay movement or actions.

const _CLASS_NAME: String = "RichTextButton"

## Theme Resource which supports [RichTextButton]. By default, it comes with
## the theme located next to the script resource.
## [br][br]
## If you wish to make changes to the styling without modifying the provided theme,
## first make the theme unique.
@export var theme_resource: Theme = load(get_script().resource_path.get_base_dir() + "/rich_text_button_theme.tres"):
	set(value):
		theme_resource = value
		if theme_resource:
			theme = theme_resource

## If [code]true[/code], the button's text uses BBCode formatting.
## [br]
## [b]Note:[/b] This only affects the contents of [member text], not the tag stack.
@export var bbcode_enabled: bool = false:
	set(value):
		bbcode_enabled = value
		if _rtl:
			_rtl.bbcode_enabled = value
		_update_rtl()
## The button's text that will be displayed inside the button's area.
@export_multiline var text: String = "":
	set(value):
		text = value
		if _rtl:
			_rtl.text = text
		_update_rtl()


var _rtl: RichTextLabel = null


func _init() -> void:
	if theme_resource:
		theme = theme_resource
	else:
		var script_path: String = get_script().resource_path
		var folder_path: String = script_path.get_base_dir()
		var theme_path: String = folder_path + "/rich_text_button_theme.tres"
		theme = load(theme_path)
	for node: Node in get_children():
		if node is RichTextLabel:
			remove_child(node)
	_init_rtl()
	_update_rtl()


func _draw() -> void:
	_update_rtl()
	
	var stylebox: StyleBox = _get_current_stylebox()
	if stylebox:
		stylebox.draw(get_canvas_item(), Rect2(Vector2.ZERO, size))
	
	if has_focus():
		var focus_stylebox: StyleBox = get_theme_stylebox("focus", _CLASS_NAME)
		focus_stylebox.draw(get_canvas_item(), Rect2(Vector2.ZERO, size))


func _get_minimum_size() -> Vector2:
	if not _rtl:
		return Vector2.ZERO
	var _size: Vector2 = _rtl.get_combined_minimum_size()
	var stylebox: StyleBox = _get_current_stylebox()
	if stylebox:
		_size.x += stylebox.content_margin_left + stylebox.content_margin_right
		_size.y += stylebox.content_margin_top + stylebox.content_margin_bottom
	return _size


func _get_current_stylebox() -> StyleBox:
	if disabled and has_theme_stylebox("disabled", _CLASS_NAME):
		return get_theme_stylebox("disabled", _CLASS_NAME)
	elif is_pressed() and has_theme_stylebox("pressed", _CLASS_NAME):
		return get_theme_stylebox("pressed", _CLASS_NAME)
	elif is_hovered():
		if is_pressed() and has_theme_stylebox("hover_pressed", _CLASS_NAME):
			return get_theme_stylebox("hover_pressed", _CLASS_NAME)
		elif has_theme_stylebox("hover", _CLASS_NAME):
			return get_theme_stylebox("hover", _CLASS_NAME)
	elif has_theme_stylebox("normal", _CLASS_NAME):
		return get_theme_stylebox("normal", _CLASS_NAME)
	return null


func _init_rtl() -> void:
	# Only create RTL once.
	if _rtl: return
	
	_rtl = RichTextLabel.new()
	_rtl.size = Vector2(0, 0)
	_rtl.bbcode_enabled = bbcode_enabled
	_rtl.fit_content = true
	_rtl.autowrap_mode = TextServer.AUTOWRAP_OFF
	_rtl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_rtl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_rtl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	add_child(_rtl)


func _update_rtl() -> void:
	if not _rtl: return
	_rtl.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_update_rtl_theme()
	update_minimum_size()


func _update_rtl_theme() -> void:
	_update_rtl_font()
	_update_rtl_color()
	_update_rtl_outline()


func _update_rtl_font() -> void:
	if not _rtl: return
	var font: Font = get_theme_font("font", _CLASS_NAME)
	var font_size: int = get_theme_font_size("font_size", _CLASS_NAME)
	if font:
		_rtl.add_theme_font_override("normal_font", font)
	if font_size > 0:
		_rtl.add_theme_font_size_override("normal_font_size", font_size)


func _update_rtl_color() -> void:
	if not _rtl: return
	var color: Color = Color(1,1,1,1)
	if disabled and has_theme_color("font_disabled_color", _CLASS_NAME):
		color = get_theme_color("font_disabled_color", _CLASS_NAME)
	elif is_pressed() and has_theme_color("font_pressed_color", _CLASS_NAME):
		color = get_theme_color("font_pressed_color", _CLASS_NAME)
	elif is_hovered():
		if is_pressed() and has_theme_color("font_hover_pressed", _CLASS_NAME):
			color = get_theme_color("font_hover_pressed", _CLASS_NAME)
		elif has_theme_color("font_hover", _CLASS_NAME):
			color = get_theme_color("font_hover", _CLASS_NAME)
	elif has_focus() and has_theme_color("font_focus_color", _CLASS_NAME):
		color = get_theme_color("font_focus_color", _CLASS_NAME)
	elif has_theme_color("font_color", _CLASS_NAME):
		color = get_theme_color("font_color", _CLASS_NAME)
	_rtl.add_theme_color_override("default_color", color)


func _update_rtl_outline() -> void:
	if not _rtl: return
	var outline_size: int = get_theme_constant("outline_size", _CLASS_NAME)
	var outline_color: Color = get_theme_color("font_outline_color", _CLASS_NAME)
	if outline_size:
		_rtl.add_theme_constant_override("outline_size", outline_size)
	if outline_color:
		_rtl.add_theme_color_override("font_outline_color", outline_color)
