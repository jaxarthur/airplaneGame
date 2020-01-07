extends Control

func _ready():
	call_deferred("set_visibility")

func set_visibility():
	_startmenu(true)
	_joinmenu(false)
	_panel(true)

func _on_Host_pressed():
	
	_startmenu(false)
	_joinmenu(false)
	_panel(false)
	
	get_node("/root/Game").host()


func _on_Join_pressed():
	
	_startmenu(false)
	_joinmenu(true)
	_panel(true)
	


func _on_JoinMenuJoin_pressed():
	var _code = get_node("JoinMenu/CodeEdit").text
	if (len(_code) == 8):
		_startmenu(false)
		_joinmenu(false)
		_panel(false)
		get_node("/root/Game").join(_code)
	else:
		printerr("That code is incorrect")


func _on_JoinMenuBack_pressed():
	
	_startmenu(true)
	_joinmenu(false)
	_panel(true)

func _startmenu(_bool):
	get_node("StartMenu").visible = _bool
	if _bool:
		get_node("StartMenu").focus_mode = Control.FOCUS_ALL
	else:
		get_node("StartMenu").focus_mode = Control.FOCUS_NONE

func _joinmenu(_bool):
	get_node("JoinMenu").visible = _bool
	if _bool:
		get_node("JoinMenu").focus_mode = Control.FOCUS_ALL
	else:
		get_node("JoinMenu").focus_mode = Control.FOCUS_NONE

func _panel(_bool):
	get_node("Panel").visible = _bool
	if _bool:
		get_node("Panel").focus_mode = Control.FOCUS_ALL
	else:
		get_node("Panel").focus_mode = Control.FOCUS_NONE

func _on_DebugJoin_pressed():
	_startmenu(false)
	_joinmenu(false)
	_panel(false)
	get_node("/root/Game").join("7f000001")
