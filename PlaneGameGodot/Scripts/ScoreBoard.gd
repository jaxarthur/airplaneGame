extends VBoxContainer
class_name ScoreBoard
# Name: 8+1 Kills: 4+1 Deaths: 4+1

func updateBoard(_playerData: Dictionary):
	var _children: Array = get_children()
	var _tiles: Array
	
	for i in _children:
		if i.name != "TitleBar":
			_tiles.append(i)
	
	_addTiles(_playerData, _tiles)
	_delTiles(_playerData, _tiles)
	_updateTiles(_playerData, _tiles)

func _addTiles(_playerData: Dictionary, _tiles: Array):
	for _key in _playerData.keys():
		var contains = false
		for _tile in _tiles:
			if _tile.name == str(_key):
				contains = true
		
		if !contains:
			print("adding")
			var _tile: Label = Label.new()
			_tile.name = str(_key)
			add_child(_tile)

func _delTiles(_playerData: Dictionary, _tiles: Array):
	var _del: Array = []
	for _tile in _tiles:
		var exists = false
		for _key in _playerData.keys():
			if _tile.name == str(_key):
				exists = true
		
		if (!exists):
			_del.append(_tile)
	
	for _tile in _del:
		_tile.free()

func _updateTiles(_playerData: Dictionary, _tiles: Array):
	for _key in _playerData.keys():
		var _tile: Label = get_node(str(_key))
		var _data: Dictionary = _playerData[_key]
		
		var _text: String = "%-8s %-4s %-4s" % [str(_data["name"]), str(_data["deaths"]), str(_data["kills"])]
		_tile.text = _text