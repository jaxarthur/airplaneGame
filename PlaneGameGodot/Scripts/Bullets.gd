extends Node
class_name Bullets

var bulletNum: int = 0
var bulletDamage: int = 25
var game: Node

func _ready():
	game = get_node("/root/Game")

func update_bullets(_bulletData: Array):
	var _bullets: Array = get_children()
	_add_bullets(_bulletData, _bullets)
	_del_bullets(_bulletData, _bullets)

func _add_bullets(_bulletData: Array, _bullets: Array):
	for i in _bulletData:
		var contains = false
		for _bullet in _bullets:
			if _bullet.name == str(i):
				contains = true
		
		if !contains:
			var _bullet: Bullet = preload("res://Scenes/Bullet.tscn").instance()
			_bullet.name = str(i)
			add_child(_bullet)

func _del_bullets(_bulletData: Array, _bullets: Array):
	for _bullet in _bullets:
		var exists = false
		for i in _bulletData:
			if _bullet.name == str(i):
				exists = true
		
		if (!exists):
			_bullet.queue_free()

func spawn_client(_pos, _rot):
	var _id: int = get_tree().get_network_unique_id()
	if (_id == 1):
		spawn(_pos, _rot, _id)
	else:
		rpc_id(1, "spawn", _pos, _rot, _id)

remote func spawn(_pos, _rot, _id):
	var bullet: Object = preload("res://Scenes/Bullet.tscn").instance()
	bullet.set_name(str(bulletNum))
	get_node("/root/Game").data["bullets"].append(bulletNum)
	bulletNum += 1
	add_child(bullet)
	bullet.translation = _pos
	bullet.rotation = _rot
	bullet.own = _id

func hit(_other, _owner):
	var _otherid: int = int(_other.name)
	game.data["players"][_otherid]["health"] -= bulletDamage
	
	if (game.data["players"][_otherid]["health"] <= 0):
		game.data["players"][_owner]["kills"] += 1
		game.data["players"][_otherid]["deaths"] += 1
