extends RigidBody
const InputManagerScript = preload("res://InputManager.gd")
var inputManager: InputManagerScript

var pitchIn: float
var rollIn: float
var yawIn: float
var throttleIn: float

var forwardThrust: float = 1000
var pitchForce: float = 10
var rollForce: float = 10
var yawForce: float = 10

var forward: Vector3
var right: Vector3
var up: Vector3
var transformBasis: Basis

func _ready():
	inputManager = find_node("InputManager")
	self.angular_damp = .99999

func _integrate_forces(state: PhysicsDirectBodyState):
	if self.is_network_master():
		update_input()
		update_vectors()
		apply_forces(state)
		sync_with_puppets()

func update_input():
	inputManager.update_input()
	pitchIn = inputManager.pitchIn
	rollIn = inputManager.rollIn
	yawIn = inputManager.yawIn
	throttleIn = inputManager.throttleIn

func update_vectors():
	transformBasis = get_global_transform().basis
	forward = -transformBasis.z
	right = transformBasis.x
	up = transformBasis.y
	
func apply_forces(state: PhysicsDirectBodyState):
	state.add_central_force(-1 * forward*throttleIn*forwardThrust)
	state.add_torque(right * pitchIn * pitchForce)
	state.add_torque(forward * rollIn * rollForce * -1)
	state.add_torque(up * yawIn * yawForce * -1)

func sync_with_puppets():
	rpc_unreliable("sync_with_master", self.global_transform)

puppet func sync_with_master(_basis):
	self.global_transform = _basis