extends VehicleBody3D

@export var health: int = 5

@export var accelaration: float = 1500.0
@export var brake_force: float = 0.5
@export var ster_angle: float = 0.5
@onready var name_label: Label3D = $Name
@onready var marker_3d: Marker3D = $Aim/Marker3D
@onready var aim: Node3D = $Aim

var is_bullet_ready:bool=true
var is_capturing:bool=false

const aim_sensitivity:float=2
const max_aim_angle:int =60
const rate_of_fire:float=1

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
func _ready() -> void:	
	name_label.text= Global.player_name if is_multiplayer_authority() else str(name)
	$Camera3D.current=is_multiplayer_authority()
	set_physics_process(is_multiplayer_authority())
	aim.visible=is_multiplayer_authority()

func _input(event: InputEvent) -> void:
		if is_capturing and event is InputEventMouseMotion:
			aim.rotate_y(-event.relative.x * aim_sensitivity/1000)
			aim.rotation_degrees=Vector3(90,clamp(aim.rotation_degrees.y,-max_aim_angle,max_aim_angle),0)
# Called every frame. 'delta' is the elapsed time since the previous frame.

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
		engine_force = -(accelaration *brake_force)

	if Input.is_action_pressed("forward"):
		engine_force = accelaration
		#if $VehicleWheel3D4.get_friction_slip() > 0.5 :
			#for i in range(5):
				#$VFX_puff_run.restart(true)
	else:
		engine_force/=1.2
		
	if Input.is_action_just_pressed("shoot"):
		print("shoot pressed")
		shoot_bullet()
		
	if is_capturing and Input.is_action_just_pressed("left_click"):
		print("shoot pressed mouse")
		shoot_bullet()
#func shoot_bullet():
	#const BULLET_3D = preload("res://scenes/fire_ball/bullet_3d.tscn")
	#var new_bullet = BULLET_3D.instantiate()
	#$Marker3D.add_child(new_bullet)
	#
	#new_bullet.global_transform =$Marker3D.global_transform

func shoot_bullet():
	print("shoot get called")
	if (is_bullet_ready):
		rpc("request_bullet_spawn",marker_3d.global_transform)
		is_bullet_ready = false
		bullet_ready()	
	#if multiplayer.is_server():
		#_spawn_bullet($Marker3D.global_transform)
	#else:
		#rpc_id(1, "request_bullet_spawn", $Marker3D.global_transform)

func bullet_ready():
	await get_tree().create_timer(1/rate_of_fire).timeout
	is_bullet_ready=true
	
@rpc("any_peer","call_local")
func request_bullet_spawn(transforms: Transform3D):
	print("2nd call")
	#if multiplayer.is_server():
	_spawn_bullet(transforms)

func _spawn_bullet(transforms: Transform3D):
	print("3rd call")
	const BULLET_3D = preload("res://scenes/fire_ball/bullet_3d.tscn")
	var bullet:Node3D = BULLET_3D.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = transforms
	
func shake():
	print("shake that car")
	apply_impulse(Vector3(0,250,0))
