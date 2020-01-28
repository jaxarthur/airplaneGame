extends Spatial
class_name Bullet

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
		var _collision: PhysicsBody = ray.get_collider()
		if _collision != null:
			if(_collision.name != "StaticBody"):
				get_node("/root/Game/Bullets").hit(_collision, own)
			
			_remove_self()
		
		ttl = ttl - delta
	
		if ttl <= 0:
			_remove_self()

remote func _sync_pos(_pos):
	self.global_transform = _pos

func _remove_self():
	queue_free()
	get_node("/root/Game").data["bullets"].erase(int(self.name))