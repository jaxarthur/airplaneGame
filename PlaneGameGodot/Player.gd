extends RigidBody
class_name Player

const InputManagerScript = preload("res://InputManager.gd")
var inputManager: InputManagerScript

var PlayerName: String = ""
var PlayerColor: Color = Color.blue

var pitchIn: float
var rollIn: float
var yawIn: float
var throttleIn: float
var fireIn: bool

var forwardThrust: float = 30
var verticalLift: float = 10
var pitchForce: float = 10
var rollForce: float = 10
var yawForce: float = 10
var propSpeed: float = .5

var fireRate: float = .05
var fireTimer: float = 0

var forward: Vector3
var right: Vector3
var up: Vector3
var transformBasis: Basis

func _ready():
	inputManager = find_node("InputManager")
	self.angular_damp = .9999
	self.linear_damp = .9
	fireTimer = fireRate
	
	#colorset
	var mat: SpatialMaterial = get_node("Body").mesh.surface_get_material(0).duplicate(true)
	mat.albedo_color = PlayerColor
	get_node("Body").mesh.surface_set_material(0, mat)

func _update():
	pass

func _integrate_forces(state: PhysicsDirectBodyState):
	if self.is_network_master():
		update_input()
		update_vectors()
		apply_forces(state)
		rotate_prop()
		update_fire()
		sync_with_puppets()

func update_input():
	inputManager.update_input()
	pitchIn = inputManager.pitchIn
	rollIn = inputManager.rollIn
	yawIn = inputManager.yawIn
	throttleIn = inputManager.throttleIn
	fireIn = inputManager.fireIn

func update_vectors():
	transformBasis = get_global_transform().basis
	forward = -transformBasis.z
	right = transformBasis.x
	up = transformBasis.y
	
func apply_forces(state: PhysicsDirectBodyState):
	state.add_central_force(-1 * forward*throttleIn*forwardThrust)
	state.add_central_force(1 * up*throttleIn*verticalLift)
	state.add_torque(right * pitchIn * pitchForce)
	state.add_torque(forward * rollIn * rollForce * -1)
	state.add_torque(up * yawIn * yawForce * -1)

func update_fire():
	if fireTimer > 0.0:
		fireTimer = fireTimer - (.01)
	if fireTimer <= 0 and fireIn:
		fireTimer = fireRate
		var _rot = rotation
		var _pos = translation + forward * -2 + up * .8
		rpc_unreliable("fire_sound")
		get_node("/root/Game/Bullets").spawn_client(_pos, _rot)
		
func rotate_prop():
	var _prop = get_node("Prop")
	_prop.global_rotate(forward, propSpeed*throttleIn) 

func sync_with_puppets():
	var _prop = get_node("Prop")
	rpc_unreliable("plane_sound", throttleIn)
	rpc_unreliable("sync_with_master", self.global_transform, _prop.global_transform)

puppet func sync_with_master(_body, _prop):
	var propObj = get_node("Prop")
	self.global_transform = _body
	propObj.global_transform = _prop

remotesync func fire_sound():
	get_node("FireSound").play()
	
remotesync func plane_sound(_speed: float):
	var _sound: AudioStreamPlayer3D = get_node("PlaneSound")
	_sound.pitch_scale = _speed /2 + .5
	if _speed > 0:
		if not _sound.playing:
			_sound.play()
	else:
		_sound.stop()
	
