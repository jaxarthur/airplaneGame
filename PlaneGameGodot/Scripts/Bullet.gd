extends Spatial

var velocity: float = 2
var ray: RayCast
var ttl: float = 3
var own: int

func _ready():
	ray = get_node("RayCast")
	ray.cast_to = Vector3(0, 0, velocity * 4)

func _physics_process(delta):
	if get_tree().is_network_server():
		translation = translation + (get_global_transform().basis.z*velocity)
		rpc_unreliable("_sync_pos", get_global_transform())
		ray.force_raycast_update()
		var _collision: Object = ray.get_collider()
		if _collision != null:
			if(_collision.is_class("Player")):
				get_node("/root/Game").bullet_hit(_collision, own)
				
			_remove_self()
		
		ttl = ttl - delta
	
		if ttl <= 0:
			rpc("_remove_self")

remote func _sync_pos(_pos):
	self.global_transform = _pos

remotesync func _remove_self():
	print("removing")
	queue_free()