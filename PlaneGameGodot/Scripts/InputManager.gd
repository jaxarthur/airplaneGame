extends Node

#Pitch Section
var pitchIn: float = 0
var pitchInUp: bool = false
var pitchInDown: bool = false
var pitchInUpJoy: float = 0
var pitchInDownJoy: float = 0
var pitchInAxis: float = 0

#Roll Section
var rollIn: float = 0
var rollInRight: bool = false
var rollInLeft: bool = false
var rollInRightJoy: float = 0
var rollInLeftJoy: float = 0
var rollInAxis: float = 0

#Yaw Section
var yawIn: float = 0
var yawInRight: bool = false
var yawInLeft: bool = false
var yawInRightJoy: float = 0
var yawInLeftJoy: float = 0
var yawInAxis: float = 0

#Throttle Section
var throttleIn: float = 0
var throttleInUp: bool = false
var throttleInDown: bool = false
var throttleInSticky: float = 0
var throttleInStickySpeed: float = .01
var throttleInUpJoy: float = 0
var throttleInDownJoy: float = 0
var throttleInAxis: float = 0
var throttleInAxisLast: float = 0
var throttleInAxisUse: bool = false

#Fire Section
var fireIn: bool = false

func update_input():
	update_input_pitch()
	update_input_roll()
	update_input_yaw()
	update_input_throttle()
	update_input_fire()

func update_input_pitch():
	pitchInUp = Input.is_action_pressed("pitch_up")
	pitchInDown = Input.is_action_pressed("pitch_down")
	pitchInUpJoy = Input.get_action_strength("pitch_up_joy")
	pitchInDownJoy = Input.get_action_strength("pitch_down_joy")
	pitchInAxis = pitchInUpJoy - pitchInDownJoy
	
	if pitchInUp or pitchInDown:
		if pitchInUp and not pitchInDown:
			pitchIn = 1
		
		elif pitchInDown and not pitchInUp:
			pitchIn = -1
		
		else:
			pitchIn = 0
	
	elif [pitchInAxis != 0]:
		pitchIn = pitchInAxis
	
	else:
		pitchIn = 0

func update_input_roll():
	rollInRight = Input.is_action_pressed("roll_right")
	rollInLeft = Input.is_action_pressed("roll_left")
	rollInRightJoy = Input.get_action_strength("roll_right_joy")
	rollInLeftJoy = Input.get_action_strength("roll_left_joy")
	rollInAxis = rollInRightJoy - rollInLeftJoy
	
	if rollInRight or rollInLeft:
		if rollInRight and not rollInLeft:
			rollIn = 1
		
		elif rollInLeft and not rollInRight:
			rollIn = -1
		
		else:
			rollIn = 0
	
	elif rollInAxis != 0:
		rollIn = rollInAxis
	
	else:
		rollIn = 0

func update_input_yaw():
	yawInRight = Input.is_action_pressed("yaw_right")
	yawInLeft = Input.is_action_pressed("yaw_left")
	yawInRightJoy = Input.get_action_strength("yaw_right_joy")
	yawInLeftJoy = Input.get_action_strength("yaw_left_joy")
	yawInAxis = yawInRightJoy - yawInLeftJoy
	
	if yawInRight or yawInLeft:
		if yawInRight and not yawInLeft:
			yawIn = 1
		
		elif yawInLeft and not yawInRight:
			yawIn = -1
		
		else:
			yawIn = 0
	
	elif yawInAxis != 0:
		yawIn = yawInAxis
	
	else:
		yawIn = 0

func update_input_throttle():
	throttleInUp = Input.is_action_pressed("throttle_up")
	throttleInDown = Input.is_action_pressed("throttle_down")
	throttleInUpJoy = Input.get_action_strength("throttle_up_joy")
	throttleInDownJoy = Input.get_action_strength("throttle_down_joy")
	throttleInAxis = throttleInUpJoy - throttleInDownJoy
	
	if throttleInUp or throttleInDown:
		if throttleInAxisUse:
			throttleInSticky = throttleIn
			throttleInAxisUse = false
		
		if throttleInUp and not throttleInDown:
			throttleInSticky = clamp(throttleInSticky+throttleInStickySpeed, 0, 1)
			
		elif throttleInDown and not throttleInUp:
			throttleInSticky = clamp(throttleInSticky-throttleInStickySpeed, 0, 1)
	
	elif throttleInAxis != throttleInAxisLast:
		throttleInAxisUse = true
		throttleInAxisLast = throttleInAxis
	
	if throttleInAxisUse:
		throttleIn = (throttleInAxis + 1) / 2
	
	else:
		throttleIn = throttleInSticky

func update_input_fire():
	fireIn = Input.is_action_pressed("fire")
