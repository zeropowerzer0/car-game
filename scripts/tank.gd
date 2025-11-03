extends VehicleBody3D

class_name tank

@onready var camera_origin: Node3D = $cameraOrigin

@export var health: int = 5

@export var ster_angle: float = 0.5
@onready var name_label: Label3D =$Name
@onready var marker_3d: Marker3D = $CSGBox3D/CSGBox3D2/CSGSphere3D/Marker3D
@onready var aim: Node3D = $CSGBox3D/CSGBox3D2
@onready var camera_3d: Camera3D = $cameraOrigin/Camera3D
@onready var aim_marker: MeshInstance3D = $CSGBox3D/CSGBox3D2/CSGSphere3D/CSGCylinder3D/AimMarker

#Class controls
@export var rate_of_fire:float=3
@export var speed:float=5



var is_bullet_ready:bool=true
var is_capturing:bool=false

const aim_sensitivity:float=2
const max_aim_angleX:int =10
const max_aim_angleY:int =180
	


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:	
	name_label.text= Global.player_name if is_multiplayer_authority() else str(name)
	print(is_multiplayer_authority())
	camera_3d.current=is_multiplayer_authority()
	set_physics_process(is_multiplayer_authority())
	aim_marker.visible=is_multiplayer_authority()

func _unhandled_input(event: InputEvent)-> void:
		if is_capturing and event is InputEventMouseMotion:
			aim.rotate_y(-event.relative.x * aim_sensitivity/1000)
			aim.rotate_z(event.relative.y * aim_sensitivity/2000)
			aim.rotation_degrees=Vector3(0,clamp(aim.rotation_degrees.y,-max_aim_angleY,max_aim_angleY),clamp(aim.rotation_degrees.z,-max_aim_angleX,max_aim_angleX))
			camera_origin.rotation_degrees=aim.rotation_degrees
			
func _physics_process(delta: float) -> void:
	
	steering = move_toward(steering,Input.get_axis("right","left")*ster_angle,delta*3.5)
	if Input.is_action_just_pressed("aim"):
		if is_capturing:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:	
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		is_capturing=not is_capturing
			
	if Input.is_action_just_pressed("reset"):
		if position.y<2:
			position.y+=5
		rotation=Vector3(0,0,0)
	if Input.is_action_pressed("brake"):
		engine_force = -250
	if Input.is_action_pressed("forward"):
		engine_force = speed*200
	
	else:
		engine_force/=1.2
		
	if Input.is_action_just_pressed("shoot"):
		print("shoot pressed")
		shoot_bullet()
	if is_capturing and Input.is_action_just_pressed("left_click"):
		print("shoot pressed mouse")
		shoot_bullet()
		
func shoot_bullet():
	print("shoot get called")
	if (is_bullet_ready):
		rpc("request_bullet_spawn",marker_3d.global_transform,aim.rotation)
		is_bullet_ready = false
		bullet_ready()	

func bullet_ready():
	await get_tree().create_timer(1/rate_of_fire).timeout
	is_bullet_ready=true
	
@rpc("any_peer","call_local")
func request_bullet_spawn(transforms: Transform3D,b_rotation:Vector3):
	print("2nd call")
	_spawn_bullet(transforms,b_rotation)

func _spawn_bullet(transforms: Transform3D,b_rotation:Vector3):
	print("3rd call")
	const BULLET_3D = preload("res://scenes/fire_ball/bullet_3d.tscn")
	var bullet:Node3D = BULLET_3D.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = transforms
	bullet.global_rotation_degrees = Vector3(-rad_to_deg(b_rotation[2]),rad_to_deg(b_rotation[1])+90+rotation_degrees.y,0)
	print(bullet.rotation_degrees)
	print(rotation_degrees.y)
func shake():
	print("shake that car")
	apply_impulse(Vector3(0,250,0))
