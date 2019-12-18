extends Node

#Pitch Section
var pitchIn: float = 0
var pitchInUp: bool = false
var pitchInDown: bool = false
var pitchInAxis: float = 0

#Roll Section
var rollIn: float = 0
var rollInRight: bool = false
var rollInLeft: bool = false
var rollInAxis: float = 0

#Yaw Section
var yawIn: float = 0
var yawInRight: bool = false
var yawInLeft: bool = false
var yawInAxis: float = 0

#Throttle Section
var throttleIn: float = 0
var throttleInUp: bool = false
var throttleInDown: bool = false
var throttleInSticky: float = 0
var throttleInStickySpeed: float = .001
var throttleInAxis: float = 0
var throttleInAxisLast: float = 0
var throttleInAxisUse: bool = false

func update_input():
	update_input_pitch()
	update_input_roll()
	update_input_yaw()
	update_input_throttle()

func update_input_pitch():
	pitchInUp = Input.is_action_pressed("pitch_up")
	pitchInDown = Input.is_action_pressed("pitch_down")
	pitchInAxis = Input.get_action_strength("pitch")
	
	if (pitchInUp or pitchInDown):
		if (pitchInUp and not pitchInDown):
			pitchIn = 1
		
		elif (pitchInDown and not pitchInDown):
			pitchIn = -1
		
		else:
			pitchIn = 0
	
	elif (pitchInAxis != 0):
		pitchIn = pitchInAxis
	
	else:
		pitchIn = 0

func update_input_roll():
	rollInRight = Input.is_action_pressed("roll_right")
	rollInLeft = Input.is_action_pressed("roll_left")
	rollInAxis = Input.get_action_strength("roll")
	
	if (rollInRight or rollInLeft):
		if (rollInRight and not rollInLeft):
			rollIn = 1
		
		elif (rollInLeft and not rollInRight):
			rollIn = -1
		
		else:
			rollIn = 0
	
	elif (rollInAxis != 0):
		rollIn = rollInAxis
	
	else:
		rollIn = 0

func update_input_yaw():
	yawInRight = Input.is_action_pressed("yaw_right")
	yawInLeft = Input.is_action_pressed("yaw_left")
	yawInAxis = Input.get_action_strength("yaw")
	
	if (yawInRight or yawInLeft):
		if (yawInRight and not yawInLeft):
			yawIn = 1
		
		elif (yawInLeft and not yawInRight):
			yawIn = -1
		
		else:
			yawIn = 0
	
	elif (yawInAxis != 0):
		yawIn = yawInAxis
	
	else:
		yawIn = 0

func update_input_throttle():
	throttleInUp = Input.is_action_pressed("throttle_up")
	throttleInDown = Input.is_action_pressed("throttle_down")
	throttleInAxis = Input.get_action_strength("throttle")
	
	if (throttleInUp or throttleInDown):
		if (throttleInAxisUse):
			throttleInSticky = throttleIn
			throttleInAxisUse = false
		
		if (throttleInUp and not throttleInDown):
			throttleInSticky = clamp(throttleInSticky+throttleInStickySpeed, 0, 1)
			
		elif (throttleInDown and not throttleInUp):
			throttleInSticky = clamp(throttleInSticky-throttleInStickySpeed, 0, 1)
	
	elif (throttleInAxis != throttleInAxisLast):
		throttleInAxisUse = true
		throttleInAxisLast = throttleInAxis
	
	if (throttleInAxisUse):
		throttleIn = throttleInAxis
	
	else:
		throttleIn = throttleInSticky