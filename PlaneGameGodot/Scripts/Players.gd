extends Node
class_name Players

var maxPlayerHealth: int = 100

func update_players(_playerData: Dictionary):
	var _players: Array = get_children()
	_add_players(_playerData, _players)
	_del_players(_playerData, _players)
	_update_players(_playerData, _players)

func _add_players(_playerData: Dictionary, _players: Array):
	for _key in _playerData.keys():
		var contains = false
		for _player in _players:
			if _player.name == str(_key):
				contains = true
		
		if !contains:
			var _player: Player = preload("res://Player.tscn").instance()
			print(_key)
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

func _update_players(_playerData: Dictionary, _players: Array):
	#Respawn Dead Planes
	var _id: int = get_tree().get_network_unique_id()
	if (_playerData.has(_id)):
		var healthTemp: ProgressBar = get_node("/root/Game/UI/ProgressBar")
		healthTemp.value = _playerData[_id]["health"]
		if(_playerData[_id]["health"] <= 0):
			_respawn_player(_id)
		
func _respawn_player(_id: int):
	var _trans: Transform = _get_spawn()
	var _player: Player = get_node(str(_id))
	_player.global_transform = _trans
	
	if (get_tree().is_network_server()):
		_regen_health(_id)
	else:
		rpc_id(1, "_regen_health", _id)

func _get_spawn():
	var spawns: Array = get_node("/root/Game/World/SpawnPoints").get_children()
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var rand: int = rng.randi_range(0, len(spawns)-1)
	var trans: Transform = spawns[rand].global_transform
	return trans

remotesync func _regen_health(_id: int):
	var network = get_node("/root/Game")
	network.data["players"][_id]["health"] = maxPlayerHealth