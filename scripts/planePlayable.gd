extends KinematicBody


export var SPEED = 1
export var ROT_SPEED = 0.45
export var z_rot = 90
export var z_rot_delta = 15
export(NodePath) var boh
onready var tween = $graphics/Tween


var direction
var time=0

var frequency = 4
var amplitude = .1

func _process(delta):
	direction=Vector3(0,int(Input.is_action_pressed("left"))-int(Input.is_action_pressed("right")),0)
	
	self.rotate(direction.normalized(), delta*ROT_SPEED)
	sineRot(delta)

func _physics_process(delta):
	move_and_slide(transform.basis.xform(Vector3.FORWARD)*SPEED)

# Animations
func _input(event):
	if event.is_action_pressed("left") or event.is_action_pressed("right"):
		var obo = int(Input.is_action_pressed("left"))-int(Input.is_action_pressed("right"))
		var newRot = z_rot+(obo*z_rot_delta)
		tween.interpolate_property($graphics, "rotation_degrees:z", $graphics.rotation_degrees.z, newRot, 1,Tween.TRANS_QUAD,Tween.EASE_OUT)
		tween.start()
	elif event.is_action_released("left") or event.is_action_released("right"):
		tween.interpolate_property($graphics, "rotation_degrees:z", $graphics.rotation_degrees.z, z_rot, 1,Tween.TRANS_QUAD,Tween.EASE_OUT)
		tween.start()

func sineRot(delta : float) -> void:
	time += delta
	var rot_z = sin(time*frequency)*amplitude
	$graphics.rotation_degrees.z += rot_z 

