class_name Character
extends KinematicBody2D


# character states
const ST_AIRBORNE = State.STNC_AIRB | State.CNCL_NORM
const ST_STANDING = State.STNC_GRND | State.CNCL_MVMT | State.CNCL_NORM
const ST_CROUCHING = State.STNC_CRCH | State.CNCL_NORM | State.CNCL_STNC


const _FLOOR_PADDING = 2	# padding above the floor collision box


export var player_slot : int = 1


var _scanner : InputScanner
var _animator : AnimationPlayer
var _max_hp : int = 100
var _hp : int = 100
var _gravity : int			# gets set in project settings
var _speed_f : int = 300	# forward walking speed
var _speed_b : int = 250	# back walking speed
var _jump_force : int = 1600
var _velocity := Vector2() setget , get_velocity
var _state : int = ST_STANDING setget , get_state


# Called when the node enters the scene tree for the first time.
func _ready():
	_scanner = InputScanner.new(player_slot)
	add_child(_scanner)
	assert(_scanner.connect("input", self, "_on_input") == OK)
	_animator = get_node("AnimationPlayer")
	_animator.play("StandingIdle")
	
	_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	var vel = _velocity * delta
	var c = move_and_collide(vel)
	if c:
		if c.collider is Floor:
			_on_hitting_floor()
		else:	# assuming that the collision is with the other character
			# move the opposing character out of the way
			var _x = c.collider.move_and_collide(Vector2(vel.x, 0))
	if _state & State.STNC_AIRB == State.STNC_AIRB:
		_velocity.y += _gravity


func stand():
	_state = ST_STANDING
	_velocity = Vector2.ZERO
	_animator.play("StandingIdle")


func walk_forward():
	_velocity.x = _speed_f
	_animator.play("WalkForward")


func walk_back():
	_velocity.x = -_speed_b
	_animator.play("WalkBack")


func jump():
	_state = ST_AIRBORNE
	_velocity.y = -_jump_force
	_animator.play("Jump")


func jump_forward():
	_velocity.x = _speed_f * 1.5
	jump()


func jump_back():
	_velocity.x = -_speed_f * 1.5
	jump()


func crouch():
	_velocity.x = 0
	_animator.play("Crouch")
	_state = ST_CROUCHING


func switch_side():
	$Sprite.set_flip_h(not $Sprite.is_flipped_h())
	_scanner.switch_side()
	_speed_f = -_speed_f
	_speed_b = -_speed_b


func is_airborne() -> bool:
	return _state & State.STNC_AIRB == State.STNC_AIRB


func get_state() -> int:
	return _state


func get_velocity():
	return _velocity


func _on_hitting_floor():
	# pad the character up just a bit
	var _x = move_and_collide(Vector2(0, -_FLOOR_PADDING))
	# re-stand character
	stand()
	# get inputs again to continue movement
	var inputs = _scanner.get_inputs()
	_on_input(inputs)


func _on_input(inputs):
	# check if crouching state has been lifted
	if (_state & State.CNCL_STNC == State.CNCL_STNC) and inputs & Inputs.D == 0:
		stand()
	# check for movement
	if _state & State.CNCL_MVMT == State.CNCL_MVMT:
		match inputs:
			Inputs.N:
				stand()
			Inputs.F:
				walk_forward()
			Inputs.B:
				walk_back()
			Inputs.U:
				jump()
			Inputs.UF:
				jump_forward()
			Inputs.UB:
				jump_back()
			Inputs.D:
				crouch()
			Inputs.DF:
				crouch()
			Inputs.DB:
				crouch()
