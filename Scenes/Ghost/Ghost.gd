extends Spatial

onready var raycast : RayCast = $Cam_y/Cam_x/Camera/RayCast
onready var tween : Tween = $Tween
onready var particles : Particles = $Particles

onready var cam_y : Spatial = $Cam_y
onready var cam_x : Spatial = $Cam_y/Cam_x

var possessed : Possessable = null

const transfer_time : float = 3.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if not tween.is_active():
		if raycast.is_colliding():
			# only collides with possessables
			var col : Possessable = raycast.get_collider().get_parent() as Possessable # gross

			if col:
				if Input.is_action_just_pressed("possess"):
					if possessed:
						possessed.possess(false)
					possessed = col
					particles.emitting = true
					tween.interpolate_property(self, "translation", translation, col.translation, transfer_time, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
					tween.start()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_control(event.relative)
		if possessed:
			pass

# camera movement of the fps object
func camera_control(vector : Vector2) -> void:
	cam_y.rotate_y(-vector.x * 0.15 * get_physics_process_delta_time())
	cam_x.rotation.x = clamp(cam_x.rotation.x + (-vector.y * 0.15 * get_physics_process_delta_time()), -1.3, 1.3)

func _tween_all_completed() -> void:
	if possessed:
		particles.emitting = false
		possessed.magnitude = 0.1
