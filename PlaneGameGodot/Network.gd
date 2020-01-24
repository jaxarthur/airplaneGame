extends Node

var code: String
var ip: String
var bulNum: int = 1
var for_removal: Array = []
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var PlayerName: String = "bob"
var PlayerColor: Color = Color.red
var playerData: Dictionary = {}
const hex: Dictionary = {"0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "a": 10, "b": 11, "c": 12, "d": 13, "e": 14, "f": 15}

#Basis Funcitons

func _ready():
	#debug tests
	ip = _get_ip()
	print("Original IP: " + ip)
	code = _encode(ip)
	print("Code: " + code)
	ip = _decode(code)
	print("New IP: " + ip)
	print("Test")

func _process(delta):
	for i in for_removal:
		i.free()
		
	for_removal = []

#Basis Networking
#Connect Fucntions To Events
func _set_connectons():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

#Start as Host
func host(_name, _color):
	PlayerName = _name
	PlayerColor = _color
	_set_connectons()
	get_node("UI").focus_mode = Control.FOCUS_NONE
	
	ip = _get_ip()
	code = _encode(ip)
	_set_code_display()
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8008, 50)
	get_tree().set_network_peer(peer)
	
	rpc("add_player", 1, PlayerName, PlayerColor, _get_spawn())

#Start as Client
func join(_code, _name, _color):
	PlayerName = _name
	PlayerColor = _color
	_set_connectons()
	
	code = _code
	ip = _decode(code)
	print(ip)
	_set_code_display()
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, 8008)
	get_tree().set_network_peer(peer)

func _player_connected(id):
	if (get_tree().get_network_unique_id() == id):
		if (get_tree().is_network_server()):
			_player_connected_server(id, PlayerName, PlayerColor)
		else:
			rpc_id(1, "_player_connected_server", id, PlayerName, PlayerColor)

remote func _player_connected_server(id, _name, _color):
	if (get_tree().is_network_server()):
		rpc_id(id, "add_player", 1, Transform.IDENTITY)
		for i in get_tree().get_network_connected_peers():
			if i != id:
				print("adding" + str(i))
				rpc_id(id, "add_player", i, Transform.IDENTITY)
		
		rpc("add_player", id, _name, _color, _get_spawn())

func _player_disconnected(id):
	if (get_tree().is_network_server()):
		rpc("remove_player", id)

func _connected_ok():
	_player_connected(get_tree().get_network_unique_id())
	_unload_menu()
	print("Connection Sucsessful")

func _server_disconnected():
	_load_menu()
	_display_menu()
	print("Connection Terminated")

func _connected_fail():
	print("Failed To Connect")
	_display_menu()

remotesync func add_player(id, _name, _color, pos):
	var player = preload("res://Player.tscn").instance()
	print(id)
	player.set_name(str(id))
	player.PlayerName = _name
	player.PlayerColor = _color
	player.set_network_master(id)
	player.global_transform = pos
	get_node("./Players").add_child(player)

remotesync func remove_player(id):
	get_node("/root/Game/Players/"+str(id)).free()

func _decode(_code: String):
	_code = _code.to_lower()
	var _ip = ""
	var _temp = 0
	for i in range(0, 8, 2):
		_temp = hex[_code[i]] * 16
		_temp = _temp + hex[_code[i+1]]
		if i != 6:
			_ip = _ip + str(_temp) + "."
		else:
			_ip = _ip + str(_temp)
	return _ip

func _encode(_ip: String):
	var _ipArray = _ip.split(".")
	var _code = ""
	var _temp = 0
	for i in _ipArray:
		_temp = hex.keys()[int(i)/ 16]
		_temp = _temp + hex.keys()[int(i) % 16]
		_code = _code + _temp
	return _code

func _get_ip() -> String:
	var _ipArray: Array = IP.get_local_addresses()
	for i in _ipArray:
		if i != "127.0.0.1" and i.find(":") < 0:
			print_debug(i)
			return i
	return ""

func _set_code_display():
	get_node("/root/Game/UI/CodeDisplay").text = "Code: {0}".format([code])

func _display_menu():
	get_node("/root/Game/Menu").set_visibility()

func _load_menu():
	var menu = preload("res://Menu.tscn").instance()
	self.add_child(menu)

func _unload_menu():
	get_node("./Menu").free()

func _get_spawn():
	var spawns: Array = get_node("./World/SpawnPoints").get_children()
	rng.randomize()
	var rand: int = rng.randi_range(0, len(spawns)-1)
	var trans: Transform = spawns[rand].global_transform
	print(trans)
	return trans

func spawn_bullet(_pos, _rot):
	if (get_tree().is_network_server()):
		_spawn_bullet_server(_pos, _rot)
	else:
		rpc_unreliable_id(1, "_spawn_bullet_server", _pos, _rot)

remotesync func _spawn_bullet_server(_pos, _rot):
	rpc_unreliable("_spawn_bullet_rpc", _pos, _rot, str(bulNum))
	bulNum += 1

remotesync func _spawn_bullet_rpc(_pos, _rot, _name):
	var bullet: Object = preload("res://Bullet.tscn").instance()
	bullet.set_name(_name)
	bullet.set_network_master(1)
	print(bullet)
	get_node("Bullets").add_child(bullet)
	bullet.translation = _pos
	bullet.rotation = _rot

func bullet_hit(_obj: Object):
	var _id: int = int(_obj.name)