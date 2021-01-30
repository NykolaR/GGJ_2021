extends KinematicBody

onready var raycast : RayCast = $RayCast

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	movement(delta)

# movement of the fps object
func movement(delta : float) -> void:
	var movement : Vector3 = Vector3()

	movement.x += Input.get_action_strength("right")
	movement.x -= Input.get_action_strength("left")

	movement.z += Input.get_action_strength("down")
	movement.z -= Input.get_action_strength("up")

	move_and_slide(movement)

# camera movement of the fps object
func camera_control(delta : float) -> void:
	pass
