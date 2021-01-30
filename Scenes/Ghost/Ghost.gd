extends Spatial

onready var raycast : RayCast = $Cam_y/Cam_x/Camera/RayCast
onready var tween : Tween = $Tween

onready var particles : Particles = $Particles
onready var fling : TextureProgress = $Fling

onready var cam_y : Spatial = $Cam_y
onready var cam_x : Spatial = $Cam_y/Cam_x

var possessed : Possessable = null

const transfer_time : float = 3.0

signal possess_released

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if false and not is_network_master():
		# current scene tree is not controlling the ghost
		# stops processing physics func & input processing; only the person playing this ghost can control them
		set_physics_process(false)
		set_process_input(false)
	else:
		# current scene tree is controlling this ghost
		fling.visible = true
		particles.visible = false

func _physics_process(delta: float) -> void:
	if not tween.is_active():
		if raycast.is_colliding():
			# only collides with possessables
			var col : Possessable = raycast.get_collider().get_parent() as Possessable # gross but is fine

			if col:
				if Input.is_action_just_pressed("possess"):
					# start fling bar movement
					tween.interpolate_property(fling, "value", 0, 1, 1, Tween.TRANS_CUBIC, Tween.EASE_IN)
					tween.start()
					connect("possess_released", self, "switch_target", [col], CONNECT_ONESHOT)

func switch_target(target : Spatial) -> void:
	tween.stop_all()
	fling.value = 0.0
	if possessed:
		possessed.possess(false)
	possessed = target
	particles.emitting = true
	#tween.interpolate_property(self, "translation", translation, target.translation, transfer_time - (fling.value*2), Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "translation", translation, target.translation, transfer_time - (pow(fling.value, 2)*2.5), Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_control(event.relative)
		if possessed and not tween.is_active():
			possessed.magnitude = clamp(event.relative.length_squared() / 1000, 0, 0.2)
	if event.is_action_released("possess"):
		emit_signal("possess_released")

# camera movement of the fps object
func camera_control(vector : Vector2) -> void:
	cam_y.rotate_y(-vector.x * 0.15 * get_physics_process_delta_time())
	cam_x.rotation.x = clamp(cam_x.rotation.x + (-vector.y * 0.15 * get_physics_process_delta_time()), -1.3, 1.3)

func _tween_all_completed() -> void:
	if possessed:
		print("movement end")
		particles.emitting = false

func _tween_completed(object : Object, key : NodePath) -> void:
	if str(key) == ":translation":
		_tween_all_completed()
		tween.stop_all()
