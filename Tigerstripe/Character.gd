class_name Character
extends KinematicBody2D


enum State {
	STANDING, CROUCHING, AIRBORNE,
	BLOCK_STANDING, BLOCK_CROUCHING,
}


const _FLOOR_PADDING = 2	# padding above the floor collision box


var _scanner : InputScanner
var _animator : AnimationPlayer
var _max_hp : int = 100
var _hp : int = 100
var _gravity : int			# gets set in project settings
var _speed_f : int = 300	# forward walking speed
var _speed_b : int = 250	# back walking speed
var _jump_force : int = 1600
var _velocity := Vector2() setget , get_velocity
var _state = State.AIRBORNE setget , get_state


# Called when the node enters the scene tree for the first time.
func _ready():
	_scanner = InputScanner.new()
	add_child(_scanner)
	assert(_scanner.connect("input", self, "_on_input") == OK)
	_animator = get_node("AnimationPlayer")
	_animator.play("StandingIdle")
	
	_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	var c = move_and_collide(_velocity * delta)
	if c:
		_on_hitting_floor()

	if _state == State.AIRBORNE:
		_velocity.y += _gravity


func stand():
	_state = State.STANDING
	_velocity = Vector2.ZERO
	_animator.play("StandingIdle")


func walk_forward():
	_velocity.x = _speed_f
	_animator.play("WalkForward")


func walk_back():
	_velocity.x = -_speed_b
	_animator.play("WalkBack")


func jump():
	_state = State.AIRBORNE
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


func is_airborne():
	return _state == State.AIRBORNE


func get_state():
	return _state


func get_velocity():
	return _velocity


func _on_hitting_floor():
	# pad the character up just a bit
	var _x = move_and_collide(Vector2(0, -_FLOOR_PADDING))
	# reset velocity
	_velocity = Vector2.ZERO
	# get inputs again to continue movement
	var stick = _scanner.get_stick_input()
	var buttons = _scanner.get_buttons()
	_state = State.STANDING
	_on_input(stick, buttons)


func _on_input(stick_dir, _buttons):
	var grounded = _state != State.AIRBORNE
	
	match stick_dir:
		InputScanner.Stick.N:
			if grounded:
				stand()
		InputScanner.Stick.F:
			if grounded:
				walk_forward()
		InputScanner.Stick.B:
			if grounded:
				walk_back()
		InputScanner.Stick.U:
			if grounded:
				jump()
		InputScanner.Stick.UF:
			if grounded:
				jump_forward()
		InputScanner.Stick.UB:
			if grounded:
				jump_back()
		InputScanner.Stick.D:
			if grounded:
				crouch()
		InputScanner.Stick.DF:
			if grounded:
				crouch()
		InputScanner.Stick.DB:
			if grounded:
				crouch()
