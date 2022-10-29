class_name Player
extends NaveBase

#atributos export
export var potencia_motor:int = 18
export var potencia_rotacion:int = 260
export var estela_maxima:int = 150

#atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

#atributos onready
onready var laser:RayoLaser = $LaserBeam2D setget ,get_laser
onready var estela:Estela = $EstelaPuntoInicio/Trail2D
onready var motor_sfx = $MotorSFX
onready var escudo:Escudo = $Escudo setget ,get_escudo

#setters y getters
func get_laser() -> RayoLaser:
	return laser
	
func get_escudo() -> Escudo:
	return escudo
	
#metodos
func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return
		
	#disparo rayo
	if event.is_action_pressed("disparo_secundario"):
		laser.set_is_casting(true)
	
	if event.is_action_released("disparo_secundario"):
		laser.set_is_casting(false)
		
	#control estela
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_points(estela_maxima)
		motor_sfx.sonido_on()
	elif event.is_action_pressed("mover_atras"):
		estela.set_max_points(0)
		motor_sfx.sonido_on()
		
	if(event.is_action_released("mover_atras") or event.is_action_released("mover_adelante")):
		motor_sfx.sonido_off()
		
	if event.is_action_pressed("escudo") and not escudo.get_esta_activado():
		escudo.activar()
		
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)

func _process(_delta: float) -> void:
	player_input()
	
#metodos custom	
func player_input() -> void:
	if not esta_input_activo():
		return
	
	empuje = Vector2.ZERO
	#Empuje
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor, 0)

	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor, 0)

	#Rotacion
	dir_rotacion = 0
	if Input.is_action_pressed("rotar_horario"):
		dir_rotacion += 1

	elif Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -= 1
		
	#Disparo
	if Input.is_action_pressed("disparo_principal"):
		canion.set_esta_disparando(true)
	
	if Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)
		
		
func esta_input_activo():
	if estado_actual in [ESTADO.MUERTO]:
		return false
	
	return true

func destruir() -> void:
	controlador_estados(ESTADO.MUERTO)
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)

func _on_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
	destruir()
