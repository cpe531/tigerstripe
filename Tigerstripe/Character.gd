class_name Character
extends KinematicBody2D


# note: I think the weird movement is because vel doesn't reset to zero when
# rapidly changing directions


enum State {
	STANDING, CROUCHING, AIRBORNE,
	BLOCK_STANDING, BLOCK_CROUCHING,
}


var _scanner : InputScanner
var _animator : AnimationPlayer
var _max_hp : int = 100
var _hp : int = 100
const _gravity = 98.0
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	var c = move_and_collide(_velocity * delta)
	if c:
		stand()
		# pad the character up just a bit
		var _x = move_and_collide(Vector2(0, -2))
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
