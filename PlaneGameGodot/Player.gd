extends RigidBody
const InputManagerScript = preload("res://InputManager.gd")
var inputManager: InputManagerScript

func _ready():
	inputManager = find_node("InputManager")

func _integrate_forces(state):
	inputManager.update_input()