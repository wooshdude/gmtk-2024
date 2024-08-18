extends Node2D

@export var disabled:bool

var elapsed = 0
var velocity = Vector2.ZERO
var mouse_relative = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if not disabled and event is InputEventMouseMotion:
		mouse_relative = event.screen_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Black magic (dont touch)
	velocity += ((mouse_relative * 0.1)-velocity) * 6.0 * delta
	#print(velocity)
	elapsed = wrap(elapsed + delta, 0, 2*PI)
	var breath = remap(sin(elapsed*1.75), -1, 1, 1.0, 1.2)
	#scale.x = (1/(2**(velocity.length()*0.05))*1.3)
	scale.y = 1/(2**(velocity.length()*0.05))
	rotation = lerp_angle(rotation, velocity.angle(), clamp(0.002+0.2*velocity.length(), 0, 1))
	global_position = Vector2(get_parent().position.x, get_parent().position.y-45)
	
	mouse_relative = Vector2.ZERO
