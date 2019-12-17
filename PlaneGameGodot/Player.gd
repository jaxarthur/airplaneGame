extends Spatial

#Pitch Section
var pitchIn: float = 0
var pitchInUp: float = 0
var pitchInDown: float = 0
var pitchInAxis: float = 0
var pitchInAxisLast: float = 0
var pitchInUseAxis: bool = false

#Roll Section
var rollIn: float = 0
var rollInUp: float = 0
var rollInDown: float = 0
var rollInAxis: float = 0
var rollInAxisLast: float = 0
var rollInUseAxis: bool = false

#Yaw Section
var yawIn: float = 0
var yawInUp: float = 0
var yawInDown: float = 0
var yawInAxis: float = 0
var yawInAxisLast: float = 0
var yawInUseAxis: bool = false

#Throttle Section
var throttleIn: float = 0
var throttleInUp: float = 0
var throttleInDown: float = 0
var throttleInSticky: float = 0
var throttleInAxis: float = 0
var throttleInAxisLast: float = 0
var throttleInUseAxis: bool = false

func _ready():
	pass
	
func _process(delta):
	if (self.is_network_master()):
		
		#Pitch Section
		pass
		
		
		
		
		
		
		
		
		
		
		
		
		
		