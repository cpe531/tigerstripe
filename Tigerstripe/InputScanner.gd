class_name InputScanner
extends Node


signal input(stick_direction, buttons)


var on_left_side = true
var last_stick_input = Stick.N setget , get_stick_input
var last_button_input = Buttons.N setget , get_buttons
var _stick_up
var _stick_right
var _stick_left
var _stick_down


enum Stick {
	UB = 7, U = 8, UF = 9,
	B  = 4, N = 5, F  = 6,
	DB = 1, D = 2, DF = 3,
}


enum Buttons { N, L, M, H }


func _init(player_slot = 1):
	var p_text = "p1_" if player_slot == 1 else "p2_"
	_stick_up = p_text + "stick_up"
	_stick_right = p_text + "stick_right"
	_stick_left = p_text + "stick_left"
	_stick_down = p_text + "stick_down"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# check all presses at once
	var buttons = Buttons.N
	var u = Input.is_action_pressed(_stick_up)
	var r = Input.is_action_pressed(_stick_right)
	var l = Input.is_action_pressed(_stick_left)
	var d = Input.is_action_pressed(_stick_down)
	var f = (r and on_left_side) or (l and not on_left_side)
	var b = (l and on_left_side) or (r and not on_left_side)
	var uf = u and f
	var df = d and f
	var ub = u and b
	var db = d and b
	# check for 'pure' directions
	var diagonal = uf or ub or df or db
	u = u and not diagonal
	f = f and not diagonal
	b = b and not diagonal
	d = d and not diagonal
	var n = not u and not f and not b and not d and not diagonal
	
	# check for cross inputs
	if u and d:
		u = false
		d = false
		n = true
	if f and b:
		f = false
		b = false
		n = true
	if uf and ub:
		uf = false
		ub = false
		n = true
	if df and db:
		df = false
		db = false
		n = true
	
	# send signals
	if u and last_stick_input != Stick.U:
		last_stick_input = Stick.U
		emit_signal("input", Stick.U, buttons)
	elif f and last_stick_input != Stick.F:
		last_stick_input = Stick.F
		emit_signal("input", Stick.F, buttons)
	elif b and last_stick_input != Stick.B:
		last_stick_input = Stick.B
		emit_signal("input", Stick.B, buttons)
	elif d and last_stick_input != Stick.D:
		last_stick_input = Stick.D
		emit_signal("input", Stick.D, buttons)
	elif uf and last_stick_input != Stick.UF:
		last_stick_input = Stick.UF
		emit_signal("input", Stick.UF, buttons)
	elif ub and last_stick_input != Stick.UB:
		last_stick_input = Stick.UB
		emit_signal("input", Stick.UB, buttons)
	elif df and last_stick_input != Stick.DF:
		last_stick_input = Stick.DF
		emit_signal("input", Stick.DF, buttons)
	elif db and last_stick_input != Stick.DB:
		last_stick_input = Stick.DB
		emit_signal("input", Stick.DB, buttons)
	elif n and last_stick_input != Stick.N:
		last_stick_input = Stick.N
		emit_signal("input", Stick.N, buttons)


func switch_side():
	on_left_side = not on_left_side


func get_stick_input():
	return last_stick_input


func get_buttons():
	return last_button_input