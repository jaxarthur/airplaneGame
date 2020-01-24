extends Control

func _ready():
	call_deferred("_show_playermenu")

#Visiblility Controls
func _background(_bool):
	visible = _bool
	if _bool:
		focus_mode = Control.FOCUS_ALL
	else:
		focus_mode = Control.FOCUS_NONE

func _startmenu(_bool):
	var _obj: HBoxContainer = get_node("CenterContainer/StartMenu")
	_obj.visible = _bool
	if _bool:
		_obj.focus_mode = Control.FOCUS_ALL
	else:
		_obj.focus_mode = Control.FOCUS_NONE

func _joinmenu(_bool):
	var _obj: HBoxContainer = get_node("CenterContainer/JoinMenu")
	_obj.visible = _bool
	if _bool:
		_obj.focus_mode = Control.FOCUS_ALL
	else:
		_obj.focus_mode = Control.FOCUS_NONE

func _playermenu(_bool):
	var _obj: HBoxContainer = get_node("CenterContainer/PlayerMenu")
	_obj.visible = _bool
	if _bool:
		_obj.focus_mode = Control.FOCUS_ALL
	else:
		_obj.focus_mode = Control.FOCUS_NONE

#Visibility Groups
func _hide_all():
	_background(false)
	_playermenu(false)
	_startmenu(false)
	_joinmenu(false)

func _show_background():
	_background(true)

func _show_playermenu():
	_hide_all()
	_show_background()
	_playermenu(true)

func _show_startmenu():
	_hide_all()
	_show_background()
	_startmenu(true)

func _show_joinmenu():
	_hide_all()
	_show_background()
	_joinmenu(true)

#External Interfaces
func _start_host():
	_hide_all()
	var _name: String = get_node("CenterContainer/PlayerMenu/NameEdit").text
	var _color: Color = get_node("CenterContainer/PlayerMenu/ColorPicker").color
	get_node("/root/Game").host(_name, _color)

func _start_client(_code):
	_hide_all()
	var _name: String = get_node("CenterContainer/PlayerMenu/NameEdit").text
	var _color: Color = get_node("CenterContainer/PlayerMenu/ColorPicker").color
	get_node("/root/Game").join(_code, _name, _color)

#Signal Handlers
func _playermenu_start():
	var _name: String = get_node("CenterContainer/PlayerMenu/NameEdit").text
	if _name.length() >= 3:
		_show_startmenu()

func _startmenu_host():
	_start_host()

func _startmenu_join():
	_show_joinmenu()

func _startmenu_debugjoin():
	_start_client("7f000001")

func _startmenu_back():
	_show_playermenu()

func _joinmenu_join():
	var _code: String = get_node("CenterContainer/JoinMenu/CodeEdit").text
	_start_client(_code)

func _joinmenu_back():
	_show_startmenu()
