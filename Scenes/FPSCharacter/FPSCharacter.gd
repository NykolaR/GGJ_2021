extends KinematicBody

onready var raycast : RayCast = $RayCast

onready var cam_y : Spatial = $Cam_y
onready var cam_x : Spatial = $Cam_y/Cam_x

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_control(event.relative)

func _physics_process(delta: float) -> void:
	movement(delta)

# movement of the fps object
func movement(delta : float) -> void:
	var movement : Vector3 = Vector3()

	movement.x += Input.get_action_strength("right")
	movement.x -= Input.get_action_strength("left")

	movement.z += Input.get_action_strength("down")
	movement.z -= Input.get_action_strength("up")

	move_and_slide(movement.rotated(Vector3.UP, cam_y.rotation.y))

# camera movement of the fps object
func camera_control(vector : Vector2) -> void:
	cam_y.rotate_y(-vector.x * 0.15 * get_physics_process_delta_time())
	cam_x.rotation.x = clamp(cam_x.rotation.x + (-vector.y * 0.15 * get_physics_process_delta_time()), -1.3, 1.3)
