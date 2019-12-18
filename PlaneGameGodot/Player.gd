extends RigidBody
const InputManagerScript = preload("res://InputManager.gd")
var inputManager: InputManagerScript

var pitchIn: float;
var rollIn: float;
var yawIn: float;
var throttleIn: float;

var forwardTrust: float = 100;

func _ready():
	inputManager = find_node("InputManager")

func _integrate_forces(state: PhysicsDirectBodyState):
	update_input()
	apply_forces(state)

func update_input():
	inputManager.update_input()
	pitchIn = inputManager.pitchIn
	rollIn = inputManager.rollIn
	yawIn = inputManager.yawIn
	throttleIn = inputManager.throttleIn

func apply_forces(state: PhysicsDirectBodyState):
	state.add_central_force(Vector3.FORWARD*throttleIn)