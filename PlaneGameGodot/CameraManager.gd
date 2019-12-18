extends Node

var camera: Camera;
var player: RigidBody;
var positionOffset: Vector3 = Vector3(0,2,-7)
var rotationOffset: Quat = Quat(Vector3(0,1,0),PI) * Quat(Vector3(1,0,0), -PI/8)
var positionSpeed: float = 60
var rotationSpeed: float = 60

var positionNew: Vector3;
var rotationNew: Vector3;

var playerBasis: Basis;
var playerPosition: Vector3;

func _ready():
	camera = find_parent("Game").find_node("Camera")
	player = find_parent("Player")

func _physics_process(delta):
	playerBasis = player.transform.basis
	playerPosition = player.translation
	
	positionNew = playerPosition + (playerBasis.x * positionOffset.x + playerBasis.y * positionOffset.y + playerBasis.z * positionOffset.z)
	
	camera.translation = camera.translation.linear_interpolate(positionNew, positionSpeed*delta)
	
	camera.transform.basis = Basis(Quat(camera.transform.basis).slerp(Quat(player.transform.basis) * rotationOffset, rotationSpeed*delta))
	
	