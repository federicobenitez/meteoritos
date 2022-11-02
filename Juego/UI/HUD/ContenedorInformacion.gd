class_name ContenedorInformacion
extends NinePatchRect

onready var texto_contenedor:Label = $Label
onready var auto_ocultar_timer:Timer = $AutoOcultarTimer
onready var animaciones:AnimationPlayer = $AnimationPlayer

export var auto_ocultar:bool = false

var esta_activo:bool = true setget set_esta_activo

#metodos
func set_esta_activo(valor:bool) -> void:
	esta_activo = valor
	
func mostrar() -> void:
	if esta_activo:
		$AnimationPlayer.play("mostrar")
	
func ocultar() -> void:
	if not esta_activo:
		$AnimationPlayer.play("ocultar")
	
func mostrar_suavizado() -> void:
	if not esta_activo:
		return 
		
	$AnimationPlayer.play("mostar_suavizado")
	if auto_ocultar:
		auto_ocultar_timer.start()
	
func ocultar_suavizado() -> void:
	if esta_activo:
		$AnimationPlayer.play("ocultar_suavizado")
	
func modificar_texto(text:String) -> void:
	texto_contenedor.text = text

func set_auto_ocultar(oculto:bool) -> void:
	if oculto:
		ocultar_suavizado()



func _on_AutoOcultarTimer_timeout() -> void:
	ocultar_suavizado()
