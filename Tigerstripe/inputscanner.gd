class_name InputScanner
extends Node


signal input(inputs)


var on_left_side = true
var last_inputs : int = 0 setget , get_inputs


# vars used for differentiating between P1 and P2 inputs
var _stick_up
var _stick_right
var _stick_left
var _stick_down
var _quick
var _direct
var _vertical
var _horizontal
var _dash


func _init(player_slot = 1):
	# change text to connect to either P1 or P2 controls
	var p_text = "p1_" if player_slot == 1 else "p2_"
	_stick_up = p_text + "stick_up"
	_stick_right = p_text + "stick_right"
	_stick_left = p_text + "stick_left"
	_stick_down = p_text + "stick_down"
	_quick = p_text + "quick"
	_direct = p_text + "direct"
	_vertical = p_text + "vertical"
	_horizontal = p_text + "horizontal"
	_dash = p_text + "dash"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# check all presses at once
	var u = Input.is_action_pressed(_stick_up)
	var r = Input.is_action_pressed(_stick_right)
	var l = Input.is_action_pressed(_stick_left)
	var d = Input.is_action_pressed(_stick_down)
	# convert to 'forward' or 'backward'
	var f = (r and on_left_side) or (l and not on_left_side)
	var b = (l and on_left_side) or (r and not on_left_side)
	
	var qck = Input.is_action_pressed(_quick)
	var dct = Input.is_action_pressed(_direct)
	var vrt = Input.is_action_pressed(_vertical)
	var hrt = Input.is_action_pressed(_horizontal)
	var dsh = Input.is_action_pressed(_dash)
	
	# fix cross inputs
	if u and d:
		u = false
		d = false
	if f and b:
		f = false
		b = false
	
	# convert to bits
	var inputs = 0
	if u:
		inputs |= Inputs.U
	if f:
		inputs |= Inputs.F
	if b:
		inputs |= Inputs.B
	if d:
		inputs |= Inputs.D
	if qck:
		inputs |= Inputs.QUICK
	if dct:
		inputs |= Inputs.DIRECT
	if vrt:
		inputs |= Inputs.VERTICAL
	if hrt:
		inputs |= Inputs.HORIZONTAL
	if dsh:
		inputs |= Inputs.DASH
	
	# send signal
	if inputs != last_inputs:
		last_inputs = inputs
		emit_signal("input", inputs)


func switch_side():
	on_left_side = not on_left_side


func get_inputs() -> int:
	return last_inputs
