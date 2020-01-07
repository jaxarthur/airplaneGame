# Typical lobby implementation; imagine this being in /root/lobby.

extends Node

var code: String
var ip: String
var players: Array = []
var hex: Dictionary = {
	"0": 0,
	"1": 1,
	"2": 2,
	"3": 3,
	"4": 4,
	"5": 5,
	"6": 6,
	"7": 7,
	"8": 8,
	"9": 9,
	"a": 10,
	"b": 11,
	"c": 12,
	"d": 13,
	"e": 14,
	"f": 15,
}

# Connect all functions

func _ready():
	ip = _get_ip()
	print("Original IP: " + ip)
	code = _encode(ip)
	print("Code: " + code)
	ip = _decode(code)
	print("New IP: " + ip)

func host():
	_set_connectons()
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8008, 50)
	get_tree().set_network_peer(peer)
	
	ip = _get_ip()
	code = _encode(ip)
	_set_code_display()

func join(_code):
	_set_connectons()
	var peer = NetworkedMultiplayerENet.new()
	code = _code
	ip = _decode(code)
	peer.create_client(ip, 8008)
	get_tree().set_network_peer(peer)
	
	_set_code_display()

func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	rpc_id(id, "register_player", id)
	print_debug("connected")

func _player_disconnected(id):
	players.erase(id) # Erase player from info.

func _connected_ok():
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	players.append(get_tree().get_network_unique_id())

	# Call function to update lobby UI here

remote func pre_configure_game():
	var selfID: int = get_tree().get_network_unique_id()

  # Load my player
	var my_player = preload("res://Player.tscn").instance()
	my_player.set_name(str(selfPeerID))
	my_player.set_network_master(selfPeerID) # Will be explained later
	get_node("./Players").add_child(my_player)

	# Load other players
	for p in player_info:
	    var player = preload("res://Player.tscn").instance()
	    player.set_name(str(p))
	    player.set_network_master(p) # Will be explained later
	    get_node("./Players").add_child(player)

	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
	#rpc_id(1, "done_preconfiguring", selfPeerID)

func _set_connectons():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func _decode(_code: String):
	_code = _code.to_lower()
	var _ip = ""
	var _temp = 0
	for i in range(0, 8, 2):
		_temp = hex[_code[i]] * 16
		_temp = _temp + hex[_code[i+1]]
		_ip = _ip + str(_temp) + "."
	return _ip.left(15)

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
