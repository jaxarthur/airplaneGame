extends Node

func update_players(_playerData: Dictionary):
	var _players: Array = get_children()
	
	_add_players(_playerData, _players)
	_del_players(_playerData, _players)

func _add_players(_playerData: Dictionary, _players: Array):
	for _key in _playerData.keys():
		var contains = false
		for _player in _players:
			if _player.name == str(_key):
				contains = true
		
		if !contains:
			var _player: Player = preload("res://Player.tscn").instance()
			_player.set_name(str(_key))
			_player.PlayerName = _playerData[_key]["name"]
			_player.PlayerColor = _playerData[_key]["color"]
			_player.set_network_master(int(_key))
			add_child(_player)

func _del_players(_playerData: Dictionary, _players: Array):
	var _del: Array = []
	for _player in _players:
		var exists = false
		for _key in _playerData.keys():
			if _player.name == str(_key):
				exists = true
		
		if (!exists):
			_player.queue_free()

func respawn_player():
	pass
